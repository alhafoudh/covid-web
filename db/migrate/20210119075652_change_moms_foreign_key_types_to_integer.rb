class ChangeMomsForeignKeyTypesToInteger < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TABLE moms
      ALTER COLUMN region_id TYPE bigint USING region_id::bigint;

      ALTER TABLE moms
      ALTER COLUMN county_id TYPE bigint USING county_id::bigint;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE moms
      ALTER COLUMN region_id TYPE character varying USING region_id::character varying;

      ALTER TABLE moms
      ALTER COLUMN county_id TYPE character varying USING county_id::character varying;
    SQL
  end
end
