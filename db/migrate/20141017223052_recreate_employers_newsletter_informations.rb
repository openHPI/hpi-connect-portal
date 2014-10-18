class RecreateEmployersNewsletterInformations < ActiveRecord::Migration
  def change
  	create_table :employers_newsletter_informations do |t|
    	t.integer :student_id
    	t.integer :employer_id
  	end
  end
end
