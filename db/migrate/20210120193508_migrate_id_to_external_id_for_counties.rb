class MigrateIdToExternalIdForCounties < ActiveRecord::Migration[6.1]
  def up
    add_column :counties, :external_id, :string
    add_index :counties, :external_id, unique: true

    execute <<-SQL
      UPDATE counties SET external_id = id;
      SELECT setval('counties_id_seq', 10000, true);
    SQL
  end

  def down
    remove_index :counties, :external_id
    remove_column :counties, :external_id

    execute <<-SQL
      SELECT setval('counties_id_seq', 1, true);
    SQL
  end
end
