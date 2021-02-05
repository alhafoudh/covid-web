require 'json/add/exception'

class ApplicationService
  def logger
    @logger ||= Rails.logger.tagged(self.class.to_s)
  end

  def track_job(klass, &block)
    job_result = klass.new(
      started_at: Time.zone.now
    )
    result = block.call
    job_result.success = true
    job_result.result = result.as_json
    result
  rescue => ex
    job_result.error = ex.to_json
    job_result.success = false
    binding.pry
  ensure
    job_result.finished_at = Time.zone.now
    job_result.save!
  end
end