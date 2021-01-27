class RychlejsieMom < Mom
  def self.instances
    [
      {
        city: 'Pezinok',
        region: Region.find_by(name: 'Bratislavský'),
        base_url: 'https://covid.pezinok.sk',
      },
      {
        city: 'Skalica',
        region: Region.find_by(name: 'Trnavský'),
        base_url: 'https://skalica.rychlejsie.sk',
      },
      {
        city: 'Bratislava',
        region: Region.find_by(name: 'Bratislavský'),
        base_url: 'https://covid.bratislava.sk',
      }
    ]
  end

  def visible?
    supports_reservation || queue_wait_time.present?
  end

  def available?(plan_dates = nil)
    supports_reservation && total_free_capacity(plan_dates) || !supports_reservation && queue_wait_time
  end

  def queue_wait_time
    external_details['queue']
  end

  def queue_wait_time_seconds
    queue = queue_wait_time.to_s
    parts = queue.match(/([0-9]{2}):([0-9]{2}):([0-9]{2})/).to_a[1..]&.map(&:to_i)
    return unless parts.present?

    hours, minutes, seconds = parts

    hours * 60 * 60 + minutes * 60 + seconds
  end
end