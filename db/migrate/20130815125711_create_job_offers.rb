class CreateJobOffers < ActiveRecord::Migration
  def change
    create_table :job_offers do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
