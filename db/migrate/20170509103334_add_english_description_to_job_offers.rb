class AddEnglishDescriptionToJobOffers < ActiveRecord::Migration[5.1]
  def change
    add_column :job_offers, :description_en, :text
    rename_column :job_offers, :description, :description_de
  end
end
