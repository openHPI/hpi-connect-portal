class DropEmployersNewsLetterInformations < ActiveRecord::Migration
  def change
    drop_table :employers_newsletter_informations
  end
end
