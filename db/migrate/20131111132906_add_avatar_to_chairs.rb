class AddAvatarToChairs < ActiveRecord::Migration[4.2]
  def up
		add_attachment :chairs, :avatar
  end

	def down 
		remove_attachment :chairs, :avatar
	end
end
