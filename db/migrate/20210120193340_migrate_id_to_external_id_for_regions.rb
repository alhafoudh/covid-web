class MigrateIdToExternalIdForRegions < ActiveRecord::Migration[6.1]
  def up
    add_column :regions, :external_id, :string
    add_index :regions, :external_id, unique: true

    execute <<-SQL
      UPDATE regions SET external_id = id;
      SELECT setval('regions_id_seq', 10000, true);
    SQL
  end

  def down
    remove_index :regions, :external_id
    remove_column :regions, :external_id

    execute <<-SQL
      SELECT setval('regions_id_seq', 1, true);
    SQL
  end
end
