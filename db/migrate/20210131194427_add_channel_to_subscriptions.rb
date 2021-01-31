class AddChannelToSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :subscriptions, :channel, :string, null: false
    add_index :subscriptions, :channel
  end
end
