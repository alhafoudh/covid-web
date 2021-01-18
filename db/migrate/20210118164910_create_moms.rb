class CreateMoms < ActiveRecord::Migration[6.1]
  def change
    create_table :moms do |t|
      t.string :title
      t.float :longitude
      t.float :latitude
      t.string :city
      t.string :street_name
      t.string :street_number
      t.string :postal_code
      t.string :region_id
      t.string :region_name
      t.string :county_id
      t.string :county_name

      t.timestamps
    end

    add_index :moms, :title
    add_index :moms, :longitude
    add_index :moms, :latitude
    add_index :moms, :city
    add_index :moms, :postal_code
    add_index :moms, :region_id
    add_index :moms, :region_name
    add_index :moms, :county_id
    add_index :moms, :county_name
  end
end
