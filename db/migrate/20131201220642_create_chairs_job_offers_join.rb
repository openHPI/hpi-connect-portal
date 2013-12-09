class CreateChairsJobOffersJoin < ActiveRecord::Migration
    def self.up
    create_table :chairs_job_offers, :id => false do |t|
    	t.integer :chair_id
    	t.integer :job_offer_id
    end
    add_index :chairs_job_offers, [:chair_id, :job_offer_id], :unique => true
  end

  def self.down
  	drop_table :chairs_job_offers
  end
end
