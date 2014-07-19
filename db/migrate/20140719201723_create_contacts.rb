class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :counterpart_id
      t.string :counterpart_type
      t.string :c_name
      t.string :c_street
      t.string :c_zip_city
      t.string :c_email
      t.string :c_phone

      t.timestamps
    end
  end
end
