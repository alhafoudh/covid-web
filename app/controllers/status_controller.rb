class StatusController < ApplicationController
  def index
    testing_update_interval = Rails.application.config.x.testing.update_interval.minutes
    vaccination_update_interval = Rails.application.config.x.vaccination.update_interval.minutes

    testing_job_result_stale_seconds = Time.zone.now.to_i - (UpdateTestingDataJobResult.last_finished_at || 0).to_i
    vaccination_job_result_stale_seconds = Time.zone.now.to_i - (UpdateVaccinationDataJobResult.last_finished_at || 0).to_i

    expires_in(Rails.application.config.x.status.content_expiration, public: true)

    render json: {
      status_at: Time.zone.now,
      region: {
        count: Region.count,
      },
      county: {
        count: County.count,
      },
      testing: {
        place_count: Mom.enabled.count,
        enabled_place_count: Mom.enabled.count,

        plan_date_count: TestDate.count,
        snapshot_count: TestDateSnapshot.count,

        last_updated_at: TestDateSnapshot.last_updated_at,
        last_updated_stale_seconds: Time.zone.now.to_i - (TestDateSnapshot.last_updated_at || 0).to_i,

        last_job_result_updated_at: UpdateTestingDataJobResult.last_finished_at,
        last_job_result_duration: UpdateTestingDataJobResult.last_finished&.duration,
        last_job_result_stale: testing_job_result_stale_seconds > testing_update_interval,
        last_job_result_stale_seconds: testing_job_result_stale_seconds,

        update_interval: testing_update_interval,
      },
      vaccination: {
        place_count: Vacc.count,
        enabled_place_count: Vacc.enabled.count,

        plan_date_count: VaccinationDate.count,
        snapshot_count: VaccinationDateSnapshot.count,

        last_updated_at: VaccinationDateSnapshot.last_updated_at,
        last_updated_stale_seconds: Time.zone.now.to_i - (VaccinationDateSnapshot.last_updated_at || 0).to_i,

        last_job_result_updated_at: UpdateVaccinationDataJobResult.last_finished_at,
        last_job_result_duration: UpdateVaccinationDataJobResult.last_finished&.duration,
        last_job_result_stale: vaccination_job_result_stale_seconds > vaccination_update_interval,
        last_job_result_stale_seconds: vaccination_job_result_stale_seconds,

        update_interval: vaccination_update_interval,
      },
    }
  end
end
