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
      deliver_to_region(region_capacities[:region], text)
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
                          {
                            plan_date: plan_date,
                            current_free_capacity: latest_snapshots_for_plan_date.map do |latest_snapshot|
                              latest_snapshot.snapshot.free_capacity
                            end.sum,
                            previous_free_capacity: latest_snapshots_for_plan_date.map do |latest_snapshot|
                              latest_snapshot.previous_snapshot&.free_capacity || 0
                            end.sum,
                          }
                        end

                        {
                          region: region,
                          plan_dates: plan_dates,
                          total_current_free_capacity: plan_dates.pluck(:current_free_capacity).sum,
                          total_previous_free_capacity: plan_dates.pluck(:previous_free_capacity).sum,
                        }
                      end
                    end
  end

  def compose_notification_text(region_capacities)
    ApplicationController.render(
      template: 'vaccination/notification/for_region',
      assigns: { region_capacities: region_capacities }
    )
  end

  def deliver_to_region(region, text)
    VaccinationSubscription.where(region: region).map do |subscription|
      subscription.deliver(text)
    end
  end
end