class CreateVaccinationDates < ActiveRecord::Migration[6.1]
  def change
    create_table :vaccination_dates do |t|
      t.date :date

      t.timestamps
    end
    add_index :vaccination_dates, :date
  end
end
