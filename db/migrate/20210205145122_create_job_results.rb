class CreateJobResults < ActiveRecord::Migration[6.1]
  def change
    create_table :job_results do |t|
      t.string :type, null: false
      t.boolean :success, null: false
      t.jsonb :result, null: false, default: {}
      t.text :error
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false

      t.timestamps
    end
    add_index :job_results, :type
    add_index :job_results, :success
    add_index :job_results, :started_at
    add_index :job_results, :finished_at
  end
end
