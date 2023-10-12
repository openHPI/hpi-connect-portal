class RenameUserChairToEmployer < ActiveRecord::Migration[4.2]
  def change
  	rename_column :users, :chair_id, :employer_id
  end
end
