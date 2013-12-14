class UsersController < ApplicationController

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            flash[:success] = 'Information updated.'
            redirect_to root_path
        else
            flash[:error] = 'Error when updating profile.'
            render 'edit'
        end
    end

    private
        def user_params
            params.require(:user).permit(:firstname, :lastname, :email, :role_id)
        end
end
