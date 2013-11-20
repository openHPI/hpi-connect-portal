class AddIdentityUrlAndIsStudentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :identity_url, :string
    add_column :users, :is_student, :boolean
  end
end
