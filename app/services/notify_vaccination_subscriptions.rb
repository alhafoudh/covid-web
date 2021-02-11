class NotifyVaccinationSubscriptions < ApplicationService
  include Rails.application.routes.url_helpers
  include ActionView::RecordIdentifier

  attr_reader :latest_snapshots

  def initialize(latest_snapshots:)
    @latest_snapshots = latest_snapshots
  end

  def perform
    logger.info "Notifying vaccination subscriptions for #{latest_snapshots.size} latest snapshots"

    return if latest_snapshots.empty?

    capacities.map do |region_capacities|
      text = compose_notification_text(region_capacities)
      deliveries = deliver_to_region(region_capacities[:region], text)
      {
        region_capacities: region_capacities,
        text: text,
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

                      # region_ids = filtered.map do |latest_snapshot|
                      #   latest_snapshot.place.region_id
                      # end.uniq
                      #
                      # plan_date_ids = filtered.map do |latest_snapshot|
                      #   latest_snapshot.plan_date.id
                      # end.uniq
                      #
                      # all_relevant_latest_snapshots_base = LatestVaccinationDateSnapshot
                      #                                        .joins(:place)
                      # all_relevant_latest_snapshots = all_relevant_latest_snapshots_base
                      #                                   .where(plan_date: plan_date_ids)
                      #                                   .or(all_relevant_latest_snapshots_base.where(place: { region: region_ids }))

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

  def compose_notification_text(region_capacities)
    NotificationsController.new.render_to_string(
      Notifications::RegionVaccinationsComponent.new(
        region: region_capacities[:region],
        plan_date_capacities: region_capacities[:plan_dates],
      ),
    )
  end

  def deliver_to_region(region, text)
    VaccinationSubscription
      .where(region: region)
      .group_by(&:channel)
      .map do |channel, subscriptions|
      user_ids = subscriptions.pluck(:user_id)
      DeliverNotificationsJob.perform_later(
        channel: channel,
        user_ids: user_ids,
        title: t('bot.vaccination_notification.title', region: region&.name || t(:other_region)),
        body: text,
      )
    end
  end
end