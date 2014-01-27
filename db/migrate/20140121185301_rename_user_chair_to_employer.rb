class RenameUserChairToEmployer < ActiveRecord::Migration
  def change
  	rename_column :users, :chair_id, :employer_id
  end
end
