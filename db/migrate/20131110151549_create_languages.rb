class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name

      t.timestamps
    end
    create_table :languages_students do |t|
      t.belongs_to :student
      t.belongs_to :language
    end
  end
end
