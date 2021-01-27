class VaccinationDateSnapshot < Snapshot
  belongs_to :place, class_name: 'Vacc', foreign_key: 'vacc_id'
  belongs_to :plan_date, class_name: 'VaccinationDate', foreign_key: 'vaccination_date_id'
end
