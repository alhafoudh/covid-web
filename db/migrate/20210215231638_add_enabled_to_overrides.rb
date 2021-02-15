class AddEnabledToOverrides < ActiveRecord::Migration[6.1]
  def change
    add_column :overrides, :enabled, :boolean, null: false, default: false
    add_index :overrides, :enabled
  end
end
