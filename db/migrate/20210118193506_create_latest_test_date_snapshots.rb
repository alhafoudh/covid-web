class CreateLatestTestDateSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :latest_test_date_snapshots do |t|
      t.references :mom, index: true, null: false, foreign_key: { on_delete: :restrict }
      t.references :test_date, index: true, null: false, foreign_key: { on_delete: :restrict }
      t.references :test_date_snapshot, index: true, null: true, foreign_key: { on_delete: :nullify }

      t.timestamps
    end

    add_index :latest_test_date_snapshots, [:mom_id, :test_date_id], unique: true
  end
end
