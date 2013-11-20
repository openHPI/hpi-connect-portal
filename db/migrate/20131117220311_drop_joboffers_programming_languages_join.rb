class DropJoboffersProgrammingLanguagesJoin < ActiveRecord::Migration

  def self.up
  	drop_table :job_offers_programming_languages
  end

  def self.down
    create_table :job_offers_programming_languages, :id => false do |t|
    	t.integer :job_offer_id
    	t.integer :programming_language_id
    end
    add_index :job_offers_programming_languages, [:job_offer_id, :programming_language_id], :unique => true, :name => "jo_pl_index"
  end
end
