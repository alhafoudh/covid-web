class AddMomsCountToRegions < ActiveRecord::Migration[6.1]
  def change
    add_column :regions, :moms_count, :integer, null: false, default: 0
  end
end
