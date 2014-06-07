class CreateCvJobs < ActiveRecord::Migration
  def change
    create_table :cv_jobs do |t|
      t.integer :student_id
      t.string :position
      t.string :employer
      t.date :from
      t.date :to
      t.boolean :current, default: false
      t.text :description

      t.timestamps
    end
  end
end
