class AddEnabledToLatestTestDateSnapshots < ActiveRecord::Migration[6.1]
  def change
    add_column :latest_test_date_snapshots, :enabled, :boolean, null: false, default: true
    add_index :latest_test_date_snapshots, :enabled
  end
end
