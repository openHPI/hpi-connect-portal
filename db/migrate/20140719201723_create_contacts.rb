class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :employer_id
      t.integer :job_offer_id
      t.string :name
      t.string :street
      t.string :zip_city
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
