class CreateChairsNewsletterInformations < ActiveRecord::Migration[4.2]
  def change
    create_table :chairs_newsletter_informations do |t|
        t.integer :user_id
        t.integer :chair_id
    end
  end
end
