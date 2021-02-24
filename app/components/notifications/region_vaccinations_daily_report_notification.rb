# frozen_string_literal: true

class Notifications::RegionVaccinationsDailyReportNotification < ViewComponent::Base
  attr_reader :region

  def initialize(region:)
    @region = region
  end

  def header
    t('notifications.region_vaccinations_daily_report_notification.messenger.header')
  end

  def report
    t(
      "notifications.region_vaccinations_daily_report_notification.messenger.report.#{region.present? ? 'region' : 'other'}",
      region: region_title,
      free_slots: t('notifications.region_vaccinations_daily_report_notification.messenger.free_slots', count: total_capacity),
      days: t('notifications.region_vaccinations_daily_report_notification.messenger.days', count: num_days),
    )
  end

  def footer
    t('notifications.region_vaccinations_daily_report_notification.messenger.footer', region_url: region_url)
  end

  def region_title
    region.present? ? region.name : nil
  end

  def region_dom_id
    region.present? ? dom_id(region) : :other_region
  end

  def region_url
    "#{vaccination_root_url}##{region_dom_id}"
  end

  def total_capacity
    plan_dates = VaccinationDate
                   .where('date >= ? AND date <= ?', Date.today, Date.today + num_days)

    region.vaccs
      .enabled
      .left_joins(
        latest_snapshots: [
          :snapshot
        ]
      )
      .where(
        latest_snapshots: {
          vaccination_date_id: plan_dates.pluck(:id)
        })
      .sum('vaccination_date_snapshots.free_capacity')
  end

  def num_days
    Rails.application.config.x.vaccination.num_plan_date_days
  end
end
