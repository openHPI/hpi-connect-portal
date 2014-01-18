class CreateJobOffersUsers < ActiveRecord::Migration
  def up
    create_table :job_offers_users, :id => false do |t|
    	t.integer :job_offer_id
    	t.integer :user_id
    end
    add_index :job_offers_users, [:job_offer_id, :user_id], :unique => true, :name => "jo_u_index"
  end

  def down
  	drop_table :job_offers_users
  end
end