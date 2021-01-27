module Capacitable
  extend ActiveSupport::Concern

  def available?(plan_dates = nil)
    total_free_capacity(plan_dates) > 0
  end

  def total_free_capacity(plan_dates = nil)
    latest_snapshots.reduce(0) do |acc, latest_snapshot|
      snapshot = latest_snapshot&.snapshot

      next acc unless snapshot.present?
      next acc if plan_dates.present? && !plan_dates.include?(snapshot.plan_date)

      free_capacity = if !latest_snapshot.enabled || snapshot.is_closed
                        0
                      else
                        snapshot.free_capacity.to_i
                      end

      acc + (free_capacity > 0 ? free_capacity : 0)
    end
  end
end
