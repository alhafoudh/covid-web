class CreateLatestVaccinationDateSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :latest_vaccination_date_snapshots do |t|
      t.references :vacc, index: { name: 'index_latest_vaccination_date_snapshots__vacc_id' }, null: false, foreign_key: { on_delete: :restrict }
      t.references :vaccination_date, index: { name: 'index_latest_vaccination_date_snapshots__date_id' }, null: false, foreign_key: { on_delete: :restrict }
      t.references :vaccination_date_snapshot, index: { name: 'index_latest_vaccination_date_snapshots__date_snapshot_id' }, null: true, foreign_key: { on_delete: :nullify }

      t.timestamps
    end
    add_index :latest_vaccination_date_snapshots, [:vacc_id, :vaccination_date_id], unique: true, name: 'idx_latest_vaccination_date_snapshots__unique_vacc_id_vdate_id'
  end
end
