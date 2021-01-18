class AddLatestTestDateSnapshotToMoms < ActiveRecord::Migration[6.1]
  def change
    add_reference :moms, :latest_test_date_snapshot, index: true, null: true, foreign_key: { on_delete: :nullify }
  end
end
