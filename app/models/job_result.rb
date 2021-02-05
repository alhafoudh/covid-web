class JobResult < ApplicationRecord
  validates :type, presence: true
  validates :success, presence: true, inclusion: { in: [true, false] }
  validates :started_at, presence: true
  validates :finished_at, presence: true
end
