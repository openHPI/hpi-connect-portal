class DropProgrammingLanguagesNewsLetterInformations < ActiveRecord::Migration
  def change
    drop_table :programming_languages_newsletter_informations
  end
end
