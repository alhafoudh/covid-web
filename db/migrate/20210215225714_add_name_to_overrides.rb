class AddNameToOverrides < ActiveRecord::Migration[6.1]
  def change
    add_column :overrides, :name, :string, null: false
  end
end
