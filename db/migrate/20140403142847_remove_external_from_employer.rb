class RemoveExternalFromEmployer < ActiveRecord::Migration[4.2]
  def change
    remove_column :employers, :external
  end
end
