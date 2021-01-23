class AddExternalEndpointToMoms < ActiveRecord::Migration[6.1]
  def change
    add_column :moms, :external_endpoint, :string
  end
end
