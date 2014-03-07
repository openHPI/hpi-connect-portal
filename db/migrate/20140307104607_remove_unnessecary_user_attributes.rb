class RemoveUnnessecaryUserAttributes < ActiveRecord::Migration
  def change
    remove_column :users, :identity_url, :string
    remove_column :users, :role_id, :integer
    remove_column :users, :employer_id, :integer
    remove_column :users, :semester, :integer
    remove_column :users, :academic_program, :string
    remove_column :users, :birthday, :date
    remove_column :users, :education, :text
    remove_column :users, :additional_information, :text
    remove_column :users, :homepage, :string
    remove_column :users, :github, :string
    remove_column :users, :facebook, :string
    remove_column :users, :xing, :string
    remove_column :users, :linkedin, :string
    remove_column :users, :user_status_id, :integer
    remove_column :users, :employment_start_date, :date

    add_column :users, :manifestation_id, :integer
    add_column :users, :manifestation_type, :string
  end
end
