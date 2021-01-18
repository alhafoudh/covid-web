class AddIndexToDateOnTestDates < ActiveRecord::Migration[6.1]
  def change
    add_index :test_dates, :date
  end
end
