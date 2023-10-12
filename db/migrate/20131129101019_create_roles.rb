class CreateRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.integer :level

      t.timestamps
    end
  end
end
