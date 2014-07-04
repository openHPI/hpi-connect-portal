class AddContactToEmployer < ActiveRecord::Migration
  def change
    add_column :employers, :contact, :text
  end
end
