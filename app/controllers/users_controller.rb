class UsersController < ApplicationController

  before_filter :check_user, :only => [:update, :edit]

    def show
      user = User.find(params[:id])
      if user.student?
        redirect_to student_path(user.id)
      elsif user.staff?
        redirect_to staff_path(user.id)
      else
        redirect_to edit_user_path(user.id)
      end
    end

    def edit
        @user = User.find(params[:id])     
    end

    def update
        @user = User.find(params[:id])

        if @user.update_attributes(user_params)
            flash[:success] = 'Information updated.'
            if @user.role.name == "Student"
                redirect_to edit_student_path(@user) 
            else
                redirect_to root_path
            end
        else
            flash[:error] = 'Error while updating profile.'
            render 'edit'
        end

        
    end

    private
        def user_params
            params.require(:user).permit(:firstname, :lastname, :email, :role_id)
        end

        def check_user
            @user = User.find(params[:id])

            if current_user != @user && !current_user.admin?
                redirect_to @user
            end
        end
end
