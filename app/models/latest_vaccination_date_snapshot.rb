class LatestVaccinationDateSnapshot < LatestSnapshot
  belongs_to :place, class_name: 'Vacc', foreign_key: 'vacc_id', touch: true

  belongs_to :plan_date, class_name: 'VaccinationDate', foreign_key: 'vaccination_date_id'
  belongs_to :snapshot, class_name: 'VaccinationDateSnapshot', foreign_key: 'vaccination_date_snapshot_id'
  belongs_to :previous_snapshot, class_name: 'VaccinationDateSnapshot', foreign_key: 'previous_snapshot_id', optional: true
end
