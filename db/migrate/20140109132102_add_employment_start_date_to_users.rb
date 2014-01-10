class AddEmploymentStartDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :employment_start_date, :date
  end
end
