class RemoveRegionNameAndCountyNameFromMoms < ActiveRecord::Migration[6.1]
  def change
    remove_column :moms, :region_name, :string
    remove_column :moms, :county_name, :string
  end
end
