class CreateJobOffersLanguages < ActiveRecord::Migration
  def self.up
    create_table :job_offers_languages, :id => false do |t|
    	t.integer :job_offer_id
    	t.integer :language_id
    end
    add_index :job_offers_languages, [:job_offer_id, :language_id], :unique => true, :name => "jo_l_index"
  end

  def self.down
  	drop_table :job_offers_languages
  end
end
