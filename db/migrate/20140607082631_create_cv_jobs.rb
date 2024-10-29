class CreateCvJobs < ActiveRecord::Migration[4.2]
  def change
    create_table :cv_jobs do |t|
      t.integer :student_id
      t.string :position
      t.string :employer
      t.date :start_date
      t.date :end_date
      t.boolean :current, default: false
      t.text :description

      t.timestamps
    end
  end
end
