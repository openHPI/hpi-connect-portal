class AddHiddenColumnsToAlumni < ActiveRecord::Migration
  def change
    add_column :alumnis, :hidden_title, :string
    add_column :alumnis, :hidden_birth_name, :string
    add_column :alumnis, :hidden_graduation_id, :integer
    add_column :alumnis, :hidden_graduation_year, :integer
    add_column :alumnis, :hidden_private_email, :string
    add_column :alumnis, :hidden_alumni_email, :string
    add_column :alumnis, :hidden_additional_email, :string
    add_column :alumnis, :hidden_last_employer, :string
    add_column :alumnis, :hidden_current_position, :string
    add_column :alumnis, :hidden_street, :string
    add_column :alumnis, :hidden_location, :string
    add_column :alumnis, :hidden_postcode, :string
    add_column :alumnis, :hidden_country, :string
    add_column :alumnis, :hidden_phone_number, :string
    add_column :alumnis, :hidden_comment, :string
    add_column :alumnis, :hidden_agreed_alumni_work, :bool
  end
end
