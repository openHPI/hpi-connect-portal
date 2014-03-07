class UsersController < ApplicationController

  def show
    user = User.find params[:id]
    if can? :read, user 
      if user.student?
        redirect_to student_path user and return
      elsif user.staff?
        redirect_to staff_path user and return
      end
    end
    redirect_to root_path
  end
end
