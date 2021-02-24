class CreateTestingPlaceCapacities < ActiveRecord::Migration[6.1]
  def change
    create_view :testing_place_capacities, materialized: true

    add_index :testing_place_capacities, [:plan_date_id, :region_id, :county_id, :latest_snapshot_id, :updated_at], unique: true, name: 'index_testing_place_capacities_fk'
  end
end
