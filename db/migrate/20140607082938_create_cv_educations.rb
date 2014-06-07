class CreateCvEducations < ActiveRecord::Migration
  def change
    create_table :cv_educations do |t|
      t.integer :student_id
      t.string :degree
      t.string :institution
      t.date :from
      t.date :to
      t.boolean :current, default: false

      t.timestamps
    end
  end
end
