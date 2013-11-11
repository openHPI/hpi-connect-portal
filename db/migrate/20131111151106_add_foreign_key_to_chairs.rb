class AddForeignKeyToChairs < ActiveRecord::Migration
  def change
		change_table :chairs do |t|
      t.integer :head_of_chair
    end
  end
end
