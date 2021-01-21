class AddVaccsCountToCounties < ActiveRecord::Migration[6.1]
  def change
    add_column :counties, :vaccs_count, :integer, null: false, default: 0
  end
end
