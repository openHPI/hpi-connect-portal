class AddUserToChair < ActiveRecord::Migration
  def change
    add_column :chairs, :deputy_id, :integer
  end
end
