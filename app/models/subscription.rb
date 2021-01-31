class Subscription < ApplicationRecord
  belongs_to :region

  enum channel: { messenger: 'messenger' }

  validates :channel, presence: true
  validates :user_id, presence: true
end
