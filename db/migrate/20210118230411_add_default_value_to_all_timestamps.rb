class AddDefaultValueToAllTimestamps < ActiveRecord::Migration[6.1]
  def up
    change_column_default :regions, :created_at, -> { 'now()' }
    change_column_default :regions, :updated_at, -> { 'now()' }

    change_column_default :counties, :created_at, -> { 'now()' }
    change_column_default :counties, :updated_at, -> { 'now()' }

    change_column_default :moms, :created_at, -> { 'now()' }
    change_column_default :moms, :updated_at, -> { 'now()' }

    change_column_default :test_dates, :created_at, -> { 'now()' }
    change_column_default :test_dates, :updated_at, -> { 'now()' }

    change_column_default :test_date_snapshots, :created_at, -> { 'now()' }
    change_column_default :test_date_snapshots, :updated_at, -> { 'now()' }

    change_column_default :latest_test_date_snapshots, :created_at, -> { 'now()' }
    change_column_default :latest_test_date_snapshots, :updated_at, -> { 'now()' }
  end

  def down
    change_column_default :regions, :created_at, nil
    change_column_default :regions, :updated_at, nil

    change_column_default :counties, :created_at, nil
    change_column_default :counties, :updated_at, nil

    change_column_default :moms, :created_at, nil
    change_column_default :moms, :updated_at, nil

    change_column_default :test_dates, :created_at, nil
    change_column_default :test_dates, :updated_at, nil

    change_column_default :test_date_snapshots, :created_at, nil
    change_column_default :test_date_snapshots, :updated_at, nil

    change_column_default :latest_test_date_snapshots, :created_at, nil
    change_column_default :latest_test_date_snapshots, :updated_at, nil
  end
end
