class AddJobOfferIdToProgrammingLanguage < ActiveRecord::Migration
  def change
    add_column :programming_languages, :job_offer_id, :integer
  end
end
