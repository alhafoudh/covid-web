class RemoveCounterCacheFromRegionsAndCounties < ActiveRecord::Migration[6.1]
  def change
    remove_column :regions, :moms_count, :integer, null: false, default: 0
    remove_column :regions, :vaccs_count, :integer, null: false, default: 0
    
    remove_column :counties, :moms_count, :integer, null: false, default: 0
    remove_column :counties, :vaccs_count, :integer, null: false, default: 0
  end
end
