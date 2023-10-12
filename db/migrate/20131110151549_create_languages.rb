class CreateLanguages < ActiveRecord::Migration[4.2]
  def change
    create_table :languages do |t|
      t.string :name

      t.timestamps
    end
    create_table :languages_users do |t|
      t.belongs_to :user
      t.belongs_to :language
      t.integer :skill
    end
  end
end
