class UsersController < ApplicationController

  has_scope :update_immediately

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    if @user.update_attributes user_params
      flash[:success] = 'Information updated.'
      if @user.student?
        redirect_to edit_student_path @user
      else
        redirect_to root_path
      end
    else
      flash[:error] = 'Error while updating profile.'
      render 'edit'
    end
  end

  def show
    user = User.find params[:id]
    if user.student?
      redirect_to student_path user.id
    elsif user.staff?
      redirect_to staff_path user.id
    else
      redirect_to root_path
    end
  end

  def userlist
    @is_deputy = User.find(params[:exclude_user]).deputy?
    @users = User.where.not(:id => params[:exclude_user]).order(:lastname)
    respond_to do |format|
      format.json { render json: { is_deputy: @is_deputy, users: @users.as_json(only: :id, methods: :full_name) } }
    end
  end

  private

    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :role_id)
    end
end
