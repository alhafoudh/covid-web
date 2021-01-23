class AddExternalDetailsToMoms < ActiveRecord::Migration[6.1]
  def change
    add_column :moms, :external_details, :jsonb
  end
end
