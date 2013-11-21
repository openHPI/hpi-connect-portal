class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.integer :semester
      t.string :academic_program
      t.date :birthday
      t.text :education
      t.text :additional_information
      t.string :homepage
      t.string :github
      t.string :facebook
      t.string :xing
      t.string :linkedin

      t.timestamps
    end
  end
end
