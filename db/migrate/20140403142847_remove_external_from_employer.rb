class RemoveExternalFromEmployer < ActiveRecord::Migration
  def change
    remove_column :employers, :external
  end
end
