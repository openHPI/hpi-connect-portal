class AddFirstnameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :firstname, :string
  end
end
