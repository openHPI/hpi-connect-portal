class RemoveHeadFromEmployer < ActiveRecord::Migration[4.2]
  def change
    remove_column :employers, :head
  end
end
