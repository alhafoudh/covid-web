class LatestVaccinationDateSnapshot < LatestSnapshot
  belongs_to :place, class_name: 'Vacc', foreign_key: 'vacc_id', touch: true

  belongs_to :plan_date, class_name: 'VaccinationDate', foreign_key: 'vaccination_date_id'
  belongs_to :snapshot, class_name: 'VaccinationDateSnapshot', foreign_key: 'vaccination_date_snapshot_id'
  belongs_to :previous_snapshot, class_name: 'VaccinationDateSnapshot', foreign_key: 'previous_snapshot_id', optional: true

  scope :notifyable, -> {
    left_joins(
      :snapshot,
      :previous_snapshot,
      :plan_date,
      place: [:region],
    )
      .where(enabled: true)
      .where('vaccination_dates.date >= ?', Date.today)
      .where.not(place: { region: nil })
      .where.not(snapshot: nil)
      .where(snapshot: { is_closed: false })
      .where('snapshot.free_capacity > 0')
      .where('snapshot.free_capacity > COALESCE(vaccination_date_snapshots.free_capacity, 0)')
      .includes(
        place: [:region]
      )
  }
end
