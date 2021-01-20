class AddTypeToMoms < ActiveRecord::Migration[6.1]
  def change
    add_column :moms, :type, :string, null: false, default: 'NcziMom'
    add_index :moms, :type
  end
end
