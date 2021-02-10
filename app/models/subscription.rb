class Subscription < ApplicationRecord
  belongs_to :region

  enum channel: { messenger: 'messenger', webpush: 'webpush' }

  validates :channel, presence: true
  validates :user_id, presence: true
end
