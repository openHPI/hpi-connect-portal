class CreateProgrammingLanguagesNewsletterInformations < ActiveRecord::Migration
  def change
    create_table :programming_languages_newsletter_informations do |t|
        t.integer :user_id
        t.integer :programming_language_id
    end
  end
end
