module RateLimits
  extend ActiveSupport::Concern

  protected

  def process_rate_limited(limit, jobs)
    limiter = Concurrent::Channel.ticker(limit)

    queue = Concurrent::Channel.new(buffer: :buffered, capacity: jobs.size)

    jobs.map do |job|
      queue << job
    end

    queue.close

    results = []
    queue.each do |job|
      ~limiter

      results << job.call
    end

    results
  end
end
