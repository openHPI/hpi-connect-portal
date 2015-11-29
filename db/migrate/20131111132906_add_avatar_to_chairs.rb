class AddAvatarToChairs < ActiveRecord::Migration
  def up
		add_attachment :chairs, :avatar
  end

	def down
		remove_attachment :chairs, :avatar
	end
end
