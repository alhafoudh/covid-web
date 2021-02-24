# frozen_string_literal: true

class Notifications::RegionVaccinationsFreeCapacityNotificationWebpush < Notifications::RegionVaccinationsFreeCapacityNotification
  def title
    region.present? ? t('notifications.region_vaccinations_free_capacity_notification.webpush.title.region', region: region_title) : t('notifications.region_vaccinations_free_capacity_notification.webpush.title.other')
  end

  def link
    region_url
  end
end
