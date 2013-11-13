class CreateProgrammingLanguages < ActiveRecord::Migration
  def change
    create_table :programming_languages do |t|
      t.string :name

      t.timestamps
    end
  end
end
