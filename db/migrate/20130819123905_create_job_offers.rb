class CreateJobOffers < ActiveRecord::Migration[4.2]
  def change
    create_table :job_offers do |t|
      t.string :description
      t.string :title

      t.timestamps
    end
  end
end
