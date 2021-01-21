class CreateVaccs < ActiveRecord::Migration[6.1]
  def up
    create_table :vaccs do |t|
      t.string :type, null: false, default: 'NcziVacc'
      t.string :external_id
      t.string :title
      t.float :longitude
      t.float :latitude
      t.string :city
      t.string :street_name
      t.string :street_number
      t.string :postal_code
      t.references :region, index: true, null: true, foreign_key: { on_delete: :restrict }
      t.references :county, index: true, null: true, foreign_key: { on_delete: :restrict }
      t.string :reservations_url

      t.timestamps
    end

    add_index :vaccs, :type
    add_index :vaccs, :external_id, unique: true
    add_index :vaccs, :longitude
    add_index :vaccs, :latitude
    add_index :vaccs, :city
    add_index :vaccs, :postal_code

    change_column_default :vaccs, :created_at, -> { 'now()' }
    change_column_default :vaccs, :updated_at, -> { 'now()' }
  end

  def down
    drop_table :vaccs
  end
end
