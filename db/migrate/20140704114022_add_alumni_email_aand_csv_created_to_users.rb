class AddAlumniEmailAandCsvCreatedToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :alumni_email, :string, null: false, default: ""
  end
end
