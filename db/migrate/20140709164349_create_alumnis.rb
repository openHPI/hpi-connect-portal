class CreateAlumnis < ActiveRecord::Migration
  def change
    create_table :alumnis do |t|
      t.string :firstname
      t.string :lastname
      t.string :email, null: false
      t.string :alumni_email, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
