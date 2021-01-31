class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.string :type, null: false
      t.string :user_id, null: false
      t.references :region, index: true, null: false, foreign_key: { on_delete: :restrict }

      t.timestamps
    end

    add_index :subscriptions, :type
    add_index :subscriptions, :user_id
  end
end
