class AddEnabledToVaccs < ActiveRecord::Migration[6.1]
  def change
    add_column :vaccs, :enabled, :boolean, null: false, default: true
    add_index :vaccs, :enabled
  end
end
