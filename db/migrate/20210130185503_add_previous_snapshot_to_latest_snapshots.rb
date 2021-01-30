class AddPreviousSnapshotToLatestSnapshots < ActiveRecord::Migration[6.1]
  def change
    add_reference :latest_test_date_snapshots, :previous_snapshot, index: true, null: true, foreign_key: { to_table: :test_date_snapshots, on_delete: :nullify }
    add_reference :latest_vaccination_date_snapshots, :previous_snapshot, index: true, null: true, foreign_key: { to_table: :vaccination_date_snapshots, on_delete: :nullify }
  end
end
