class AddChannelUserIdCompositeIndexToSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_index :subscriptions, [:channel, :user_id]
  end
end
