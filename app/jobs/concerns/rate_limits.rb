module RateLimits
  extend ActiveSupport::Concern

  protected

  def process_rate_limited(limit, jobs)
    jobs.map do |job|
      result = job.call
      sleep limit
      result
    end
  end
end
