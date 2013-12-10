class CreateProgrammingLanguages < ActiveRecord::Migration
  def change
    create_table :programming_languages do |t|
      t.string :name

      t.timestamps
    end
    create_table :programming_languages_students do |t|
      t.belongs_to :student
      t.belongs_to :programming_language
      t.integer :skill
    end
  end
end
