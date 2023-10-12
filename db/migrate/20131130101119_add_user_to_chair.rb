class AddUserToChair < ActiveRecord::Migration[4.2]
  def change
    add_column :chairs, :deputy_id, :integer
  end
end
