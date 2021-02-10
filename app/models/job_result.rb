class JobResult < ApplicationRecord
  validates :type, presence: true
  validates :success, inclusion: { in: [true, false] }
  validates :started_at, presence: true
  validates :finished_at, presence: true

  def self.last_finished
    order(finished_at: :desc).first
  end

  def self.last_finished_at
    last_finished&.finished_at
  end

  def duration
    finished_at - started_at
  end
end
