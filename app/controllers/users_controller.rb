class UsersController < ApplicationController

	def register
		@user = User.find_by_id(params[:id])
	end
	
end
