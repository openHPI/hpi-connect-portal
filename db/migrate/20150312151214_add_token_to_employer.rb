class AddTokenToEmployer < ActiveRecord::Migration
  def up
    add_column :employers, :token, :string
    Employer.all.each do |employer|
      employer.generate_unique_token
      employer.save
    end
  end
  def down
    remove_column :employers, :token
  end
end
