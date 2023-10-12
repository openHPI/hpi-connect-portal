class DropEmployersNewsLetterInformations < ActiveRecord::Migration[4.2]
  def change
    drop_table :employers_newsletter_informations
  end
end
