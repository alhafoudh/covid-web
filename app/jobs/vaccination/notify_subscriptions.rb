module Vaccination
  class NotifySubscriptions < ApplicationJob
    include Rails.application.routes.url_helpers
    include ActionView::RecordIdentifier

    attr_reader :latest_snapshots

    def perform(latest_snapshots:)
      @latest_snapshots = latest_snapshots

      logger.info "Notifying subscriptions for #{latest_snapshots.size} latest snapshots"

      return if latest_snapshots.empty?

      capacities.map do |region_capacities|
        deliveries = deliver_to_region(region_capacities)
        {
          region_capacities: region_capacities,
          deliveries: deliveries,
        }
      end
    end

    private

    def capacities
      @capacities ||= begin
                        filtered = LatestVaccinationDateSnapshot
                                     .notifyable
                                     .where(id: latest_snapshots.pluck(:id))

                        by_region = filtered.group_by do |latest_snapshot|
                          latest_snapshot.place.region
                        end

                        by_region.map do |region, latest_snapshots_for_region|
                          plan_dates = latest_snapshots_for_region
                                         .group_by(&:plan_date)
                                         .sort_by do |plan_date, _|
                            plan_date.date
                          end
                                         .map do |plan_date, latest_snapshots_for_plan_date|
                            current_free_capacity = latest_snapshots_for_plan_date.map do |latest_snapshot|
                              latest_snapshot.snapshot.free_capacity
                            end.sum
                            previous_free_capacity = latest_snapshots_for_plan_date.map do |latest_snapshot|
                              latest_snapshot.previous_snapshot&.free_capacity || 0
                            end.sum

                            {
                              plan_date: plan_date,
                              current_free_capacity: current_free_capacity,
                              previous_free_capacity: previous_free_capacity,
                              capacity_delta: current_free_capacity - previous_free_capacity,
                            }
                          end

                          total_current_free_capacity = plan_dates.pluck(:current_free_capacity).sum
                          total_previous_free_capacity = plan_dates.pluck(:previous_free_capacity).sum

                          {
                            region: region,
                            plan_dates: plan_dates,
                            total_current_free_capacity: total_current_free_capacity,
                            total_previous_free_capacity: total_previous_free_capacity,
                            capacity_delta: total_current_free_capacity - total_previous_free_capacity,
                          }
                        end
                      end
    end

    def deliver_to_region(capacities)
      region = capacities[:region]

      if capacities[:capacity_delta] <= free_capacity_threshold
        logger.info "Skipping notification delivery for Region ##{region&.id} #{region&.name}, because free capacity threshold #{free_capacity_threshold} is not met. Delta is #{capacities[:capacity_delta]}."
        return []
      end

      logger.info "Preparing notification delivery for Region ##{region&.id} #{region&.name}"

      component_cache = {}

      VaccinationSubscription
        .where(region: region)
        .group_by(&:channel)
        .map do |channel, subscriptions|
        component = if channel == 'webpush'
                      component_cache[[region, channel]] ||= Notifications::RegionVaccinationsFreeCapacityNotificationWebpush.new(
                        region: region,
                        plan_date_capacities: capacities[:plan_dates],
                      )
                    elsif channel == 'messenger'
                      component_cache[[region, channel]] ||= Notifications::RegionVaccinationsFreeCapacityNotificationMessenger.new(
                        region: region,
                        plan_date_capacities: capacities[:plan_dates],
                      )
                    else
                      raise NotImplementedError
                    end
        title = component.title
        body = NotificationsController.render(component)
        link = component.link

        user_ids = subscriptions.pluck(:user_id)

        logger.info "Notifying #{user_ids.size} subscriptions about Region ##{region&.id} #{region&.name} using #{channel} channel."

        DeliverNotificationsJob
          .perform_later(
            channel: channel,
            user_ids: user_ids,
            notification: {
              title: title,
              body: '',
            },
            data: {
              id: SecureRandom.hex,
              title: title,
              body: body,
              link: link,
            },
            webpush: {
              fcm_options: {
                link: link,
              },
            },
          )

        {
          region: region,
          channel: channel,
          user_ids: user_ids,
          title: title,
          body: body,
          link: link,
        }
      end
    end

    def free_capacity_threshold
      Rails.application.config.x.notifications.free_capacity_threshold
    end
  end
end