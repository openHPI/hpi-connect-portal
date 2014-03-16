class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :semester
      t.string :academic_program
      t.text :education
      t.text :additional_information
      t.date :birthday
      t.string :homepage
      t.string :github
      t.string :facebook
      t.string :xing
      t.string :linkedin
      t.string :employment_status

      t.timestamps
    end
  end
end
