class RenameChairsNewsletterInformationToEmployersNewsletterInformation < ActiveRecord::Migration
  def change
    rename_table :chairs_newsletter_informations, :employers_newsletter_information
    rename_column :employers_newsletter_information, :chair_id, :employer_id
  end
end
