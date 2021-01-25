class AddEnabledToMoms < ActiveRecord::Migration[6.1]
  def change
    add_column :moms, :enabled, :boolean, null: false, default: true
    add_index :moms, :enabled
  end
end
