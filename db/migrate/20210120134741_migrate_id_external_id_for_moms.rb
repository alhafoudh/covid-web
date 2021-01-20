class MigrateIdExternalIdForMoms < ActiveRecord::Migration[6.1]
  def up
    add_column :moms, :external_id, :string
    add_index :moms, :external_id, unique: true

    execute <<-SQL
      UPDATE moms SET external_id = id;
      SELECT setval('moms_id_seq', 10000, true);
    SQL
  end

  def down
    remove_index :moms, :external_id
    remove_column :moms, :external_id

    execute <<-SQL
      SELECT setval('moms_id_seq', 1, true);
    SQL
  end
end
