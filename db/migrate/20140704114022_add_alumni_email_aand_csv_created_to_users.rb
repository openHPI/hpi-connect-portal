class AddAlumniEmailAandCsvCreatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alumni_email, :string, null: false, default: ""
  end
end
