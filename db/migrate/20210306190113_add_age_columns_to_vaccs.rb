class AddAgeColumnsToVaccs < ActiveRecord::Migration[6.1]
  def change
    add_column :vaccs, :age_from, :string
    add_column :vaccs, :age_to, :string
  end
end
