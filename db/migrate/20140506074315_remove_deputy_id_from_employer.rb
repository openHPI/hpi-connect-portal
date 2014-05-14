class RemoveDeputyIdFromEmployer < ActiveRecord::Migration
  def change
    remove_column :employers, :deputy_id
  end
end
