class RemoveDeviseFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :last_sign_in_ip, :string

    add_column :users, :password_digest, :string
    add_column :users, :activated, :boolean, null: false, default: false
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
