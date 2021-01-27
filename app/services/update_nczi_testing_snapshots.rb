class UpdateNcziTestingSnapshots < TestingSnapshotsBase
  include NcziClient

  attr_reader :mom

  def initialize(mom:)
    @mom = mom
  end

  def perform
    logger.info "Updating NCZI test date snapshots for mom #{mom.inspect}"

    ActiveRecord::Base.transaction do
      snapshots = create_snapshots!(fetch_snapshots)
      update_latest_snapshots!(snapshots)
    end
  end

  private

  def fetch_snapshots
    data = fetch_raw_snapshots
    plan_dates_statuses = data.fetch('payload', [])

    plan_dates_statuses.map do |plan_date_status|
      parsed_date = Date.parse(plan_date_status['c_date'])
      plan_date = plan_dates.find do |plan_date|
        plan_date.date == parsed_date
      end

      unless plan_date.present?
        plan_date = TestDate.find_or_create_by!(
          date: parsed_date,
        )
      end

      TestDateSnapshot.new(
        plan_date: plan_date,
        mom_id: mom.id,
        is_closed: plan_date_status['is_closed'] == '1',
        free_capacity: plan_date_status.fetch('free_capacity', 0).to_i,
      )
    end
  end

  def plan_dates
    @plan_dates ||= TestDate.all.to_a
  end

  def fetch_raw_snapshots
    response = nczi_client.post('https://mojeezdravie.nczisk.sk/api/v1/web/validate_drivein_times', { drivein_id: mom.external_id.to_s })
    response.body
  end
end