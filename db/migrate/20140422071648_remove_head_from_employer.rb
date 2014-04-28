class RemoveHeadFromEmployer < ActiveRecord::Migration
  def change
    remove_column :employers, :head
  end
end
