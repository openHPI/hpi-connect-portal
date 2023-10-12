class ChangeForeignKeyForEmployerNewslettersToStudent < ActiveRecord::Migration[4.2]
  def change
    rename_column :employers_newsletter_informations, :user_id, :student_id
  end
end
