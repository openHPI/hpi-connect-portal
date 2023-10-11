class RemoveDeputyIdFromEmployer < ActiveRecord::Migration[4.2]
  def change
    remove_column :employers, :deputy_id
  end
end
