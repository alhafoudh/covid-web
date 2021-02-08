class AddUniqueIndexToSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_index :subscriptions, [:type, :channel, :user_id, :region_id], unique: true, name: 'index_unique_on_subscriptions'
  end
end
