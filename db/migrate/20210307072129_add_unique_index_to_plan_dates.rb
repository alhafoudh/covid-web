class AddUniqueIndexToPlanDates < ActiveRecord::Migration[6.1]
  def up
    delete_duplicate_plan_date(TestDate, TestDateSnapshot, LatestTestDateSnapshot)
    delete_duplicate_plan_date(VaccinationDate, VaccinationDateSnapshot, LatestVaccinationDateSnapshot)

    remove_index :test_dates, :date
    remove_index :vaccination_dates, :date

    add_index :test_dates, :date, unique: true
    add_index :vaccination_dates, :date, unique: true
  end

  def down
    remove_index :test_dates, :date, unique: true
    remove_index :vaccination_dates, :date, unique: true

    add_index :test_dates, :date
    add_index :vaccination_dates, :date
  end

  def delete_duplicate_plan_date(plan_date_class, snapshot_class, latest_snapshot_class)
    plan_date_class.all
      .order(:id)
      .reduce({}) do |acc, plan_date|
      if acc.has_key?(plan_date.date)
        other_plan_date = acc[plan_date.date]
        puts "Deleting #{plan_date.inspect} because we already have #{other_plan_date.inspect}"

        snapshot_class.where(plan_date: plan_date).delete_all
        latest_snapshot_class.where(plan_date: plan_date).delete_all

        plan_date.destroy!
      else
        acc[plan_date.date] = plan_date
      end
      acc
    end
  end
end
