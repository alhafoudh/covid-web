class AddIndexToExternalEndpointOnMoms < ActiveRecord::Migration[6.1]
  def change
    add_index :moms, :external_endpoint
  end
end
