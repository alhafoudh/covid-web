class Vacc < Place
  has_many :snapshots, class_name: 'VaccinationDateSnapshot'
  has_many :latest_snapshots, class_name: 'LatestVaccinationDateSnapshot'

  def supports_reservation
    false
  end
end
