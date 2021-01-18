class CreateCounties < ActiveRecord::Migration[6.1]
  def change
    create_table :counties do |t|
      t.references :region, index: true, null: true, foreign_key: { on_delete: :restrict }

      t.string :name

      t.integer :moms_count, null: false, default: 0

      t.timestamps
    end
  end
end
