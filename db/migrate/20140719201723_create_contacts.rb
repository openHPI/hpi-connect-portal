class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :counterpart_id
      t.string :counterpart_type
      t.string :name
      t.string :street
      t.string :zip_city
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
