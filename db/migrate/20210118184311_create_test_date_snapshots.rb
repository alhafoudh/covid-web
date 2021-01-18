class CreateTestDateSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :test_date_snapshots do |t|
      t.references :mom, index: true, null: false, foreign_key: { on_delete: :restrict }
      t.references :test_date, index: true, null: false, foreign_key: { on_delete: :restrict }

      t.boolean :is_closed, null: false
      t.integer :free_capacity, null: false, default: 0

      t.timestamps
    end

    add_index :test_date_snapshots, :is_closed
    add_index :test_date_snapshots, :free_capacity
    add_index :test_date_snapshots, :created_at
  end
end
