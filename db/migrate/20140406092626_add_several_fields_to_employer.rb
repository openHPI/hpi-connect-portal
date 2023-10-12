class AddSeveralFieldsToEmployer < ActiveRecord::Migration[4.2]
  def change
    add_column :employers, :place_of_business, :string
    add_column :employers, :website, :string
    add_column :employers, :line_of_business, :string
    add_column :employers, :year_of_foundation, :integer
    add_column :employers, :number_of_employees, :string
  end
end
