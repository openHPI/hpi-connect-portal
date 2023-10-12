class DropProgrammingLanguagesNewsLetterInformations < ActiveRecord::Migration[4.2]
  def change
    drop_table :programming_languages_newsletter_informations
  end
end
