class CreateAssignments < ActiveRecord::Migration[4.2]

  def up
    create_table :assignments do |t|
      t.integer :student_id
      t.integer :job_offer_id

      t.timestamps
    end
  end

  def down
    drop_table :assignments
    create_table :job_offers_users, :id => false do |t|
      t.integer :job_offer_id
      t.integer :user_id
    end
    add_index :job_offers_users, [:job_offer_id, :user_id], :unique => true, :name => "jo_u_index"
  end
end
