class UpdateAllMomTestDateSnapshots < ApplicationService
  attr_reader :rate_limit

  def initialize(rate_limit: 1)
    @rate_limit = rate_limit
  end

  def perform
    ActiveRecord::Base.transaction do
      moms_count = Mom.count
      jobs = job_queue_for(moms_count)
      limiter = get_limiter

      Mom.find_each(batch_size: 50) do |mom|
        jobs << UpdateMomTestDateSnapshots.new(mom: mom)
      end

      jobs.close

      jobs.each do |req|
        ~limiter

        req.perform
      end
    end
  end

  private

  def get_limiter
    Concurrent::Channel.ticker(rate_limit)
  end

  def job_queue_for(size)
    Concurrent::Channel.new(buffer: :buffered, capacity: size)
  end
end