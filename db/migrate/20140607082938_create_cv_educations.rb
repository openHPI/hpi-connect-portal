class CreateCvEducations < ActiveRecord::Migration[4.2]
  def change
    create_table :cv_educations do |t|
      t.integer :student_id
      t.string :degree
      t.string :field
      t.string :institution
      t.date :start_date
      t.date :end_date
      t.boolean :current, default: false

      t.timestamps
    end
  end
end
