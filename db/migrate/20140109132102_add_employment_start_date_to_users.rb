class AddEmploymentStartDateToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :employment_start_date, :date
  end
end
