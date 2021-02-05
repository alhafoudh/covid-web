class UpdateAllVacuumlabsTestingSnapshotsEach < ApplicationService
  attr_reader :rate_limit

  def initialize(rate_limit: 1)
    @rate_limit = rate_limit
  end

  def perform
    ActiveRecord::Base.transaction do
      all_jobs = []
      limiter = get_limiter

      VacuumlabsMom
        .includes(
          latest_snapshots: [
            :plan_date,
            { snapshot: [:plan_date] }
          ]
        )
        .find_each(batch_size: 50) do |mom|
        all_jobs << UpdateVacuumlabsTestingSnapshots.new(mom: mom)
      end

      jobs = job_queue_for(all_jobs.size)
      all_jobs.map do |job|
        jobs << job
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