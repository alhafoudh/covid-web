class AddReservationsUrlToMoms < ActiveRecord::Migration[6.1]
  def change
    add_column :moms, :reservations_url, :string
  end
end
