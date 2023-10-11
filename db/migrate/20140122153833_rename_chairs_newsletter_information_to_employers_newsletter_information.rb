class RenameChairsNewsletterInformationToEmployersNewsletterInformation < ActiveRecord::Migration[4.2]
  def change
    rename_table :chairs_newsletter_informations, :employers_newsletter_informations
    rename_column :employers_newsletter_informations, :chair_id, :employer_id
  end
end
