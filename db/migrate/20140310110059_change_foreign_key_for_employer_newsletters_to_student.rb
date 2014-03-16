class ChangeForeignKeyForEmployerNewslettersToStudent < ActiveRecord::Migration
  def change
    rename_column :employers_newsletter_informations, :user_id, :student_id
  end
end
