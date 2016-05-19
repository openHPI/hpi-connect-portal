class AddHiddenColumnsToStudent < ActiveRecord::Migration
  def change
    add_column :students, :hidden_title, :string
    add_column :students, :hidden_birth_name, :string
    add_column :students, :hidden_graduation_id, :integer
    add_column :students, :hidden_graduation_year, :integer
    add_column :students, :hidden_private_email, :string
    add_column :students, :hidden_alumni_email, :string
    add_column :students, :hidden_additional_email, :string
    add_column :students, :hidden_last_employer, :string
    add_column :students, :hidden_current_position, :string
    add_column :students, :hidden_street, :string
    add_column :students, :hidden_location, :string
    add_column :students, :hidden_postcode, :string
    add_column :students, :hidden_country, :string
    add_column :students, :hidden_phone_number, :string
    add_column :students, :hidden_comment, :string
    add_column :students, :hidden_agreed_alumni_work, :bool
  end
end