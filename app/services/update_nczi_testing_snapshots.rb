class UpdateNcziTestingSnapshots < TestingSnapshotsBase
  include NcziClient

  attr_reader :mom, :data

  def initialize(mom:, data: nil)
    @mom = mom
    @data = data
  end

  def perform
    logger.info "Updating NCZI test date snapshots for mom ##{mom.id}"

    ActiveRecord::Base.transaction do
      snapshots = fetch_snapshots
      created_snapshots = create_snapshots!(snapshots)
      latest_snapshots = update_latest_snapshots!(created_snapshots)
      disable_latest_snapshots!(snapshots)

      logger.info "Done updating NCZI testing date snapshots. Currently we have #{mom.latest_snapshots.enabled.count} enabled latest snapshots."

      latest_snapshots
    end
  end

  private

  def fetch_snapshots
    plan_dates_statuses = fetch_raw_snapshots

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
    if data.nil?
      response = if Rails.application.config.x.nczi.use_proxy
                   nczi_client.get("https://data.korona.gov.sk/ncziapi/validate_drivein_times?drivein_id=#{mom.external_id.to_s}")
                 else
                   nczi_client.post('https://mojeezdravie.nczisk.sk/api/v1/web/validate_drivein_times', { drivein_id: mom.external_id.to_s })
                 end
      response.body.fetch('payload', [])
    else
      data
    end
  end
end