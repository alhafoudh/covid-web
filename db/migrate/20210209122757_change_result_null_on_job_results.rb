class ChangeResultNullOnJobResults < ActiveRecord::Migration[6.1]
  def change
    change_column_null :job_results, :result, true
  end
end
