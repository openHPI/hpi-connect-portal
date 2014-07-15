class RemoveContactFromEmployer < ActiveRecord::Migration
  def change
  	remove_column :employers, :contact
  end
end
