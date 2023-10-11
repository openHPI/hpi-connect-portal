class AddIdentityUrlAndIsStudentToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :identity_url, :string
    add_column :users, :is_student, :boolean
  end
end
