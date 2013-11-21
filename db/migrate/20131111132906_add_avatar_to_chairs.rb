class AddAvatarToChairs < ActiveRecord::Migration
  def self.up
		add_attachment :chairs, :avatar
  end

	def self.down 
		remove_attachment :chairs, :avatar
	end
end
