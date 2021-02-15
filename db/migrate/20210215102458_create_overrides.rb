class CreateOverrides < ActiveRecord::Migration[6.1]
  def change
    create_table :overrides do |t|
      t.string :type, null: false
      t.jsonb :matches, null: false, default: []
      t.jsonb :replacements, null: false, default: []

      t.timestamps
    end
  end
end
