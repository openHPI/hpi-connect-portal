class CreateJoboffersProgrammingLanguagesJoin < ActiveRecord::Migration[4.2]
  def up
    create_table :job_offers_programming_languages, :id => false do |t|
    	t.integer :job_offer_id
    	t.integer :programming_language_id
    end
    add_index :job_offers_programming_languages, [:job_offer_id, :programming_language_id], :unique => true, :name => "jo_pl_index"
  end

  def down
  	drop_table :job_offers_programming_languages
  end
end
