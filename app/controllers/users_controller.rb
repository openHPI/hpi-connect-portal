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

  def userlist
    is_deputy = User.find(params[:exclude_user]).deputy?
    is_deputy = is_deputy == nil ? false : is_deputy
    users = User.where.not(id: params[:exclude_user]).order(:lastname)
    respond_to do |format|
      format.json { render json: { is_deputy: is_deputy, users: users.as_json(only: :id, methods: :full_name) } }
    end
  end

end
