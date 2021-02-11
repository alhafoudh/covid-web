# frozen_string_literal: true

class Notifications::RegionVaccinationsFreeCapacityNotificationMessenger < Notifications::RegionVaccinationsFreeCapacityNotification
  def header
    region.present? ?
      t('notifications.vaccination_notification.messenger.header.region', region: region_title, delta: total_capacity_delta) :
      t('notifications.vaccination_notification.messenger.header.other', delta: total_capacity_delta)
  end

  def footer
    t('notifications.vaccination_notification.messenger.footer', region_url: region_url)
  end

  def title
    nil
  end

  def link
    nil
  end
end
