class AddSupportsReservationToMoms < ActiveRecord::Migration[6.1]
  def change
    add_column :moms, :supports_reservation, :boolean, null: false, default: true
    add_index :moms, :supports_reservation
  end
end
