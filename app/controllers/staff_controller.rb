class StaffController < ApplicationController
  include UsersHelper

  authorize_resource class: "User"
  #before_filter :check_user_can_index_staff, only: [:index]
  #before_filter :check_current_user_or_admin, only: [:edit]

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  rescue_from CanCan::AccessDenied do |exception|
    if [:index].include? exception.action
      respond_and_redirect_to root_path, exception.message
    elsif [:edit].include? exception.action
      respond_and_redirect_to exception.subject, exception.message
    else
      respond_and_redirect_to staff_index_path, exception.message
    end
  end

  # GET /staff
  # GET /staff.json
  def index
    authorize! :index, User.staff
    @users = apply_scopes(User.staff).sort_by{|user| [user.lastname, user.firstname]}.paginate(page: params[:page], per_page: 5)
  end

  # GET /staff/1
  # GET /staff/1.json
  def show
    @user = User.find params[:id]
    if not @user.staff?
      redirect_to user_path
    end
  end

  # GET /staff/1/edit
  def edit
    authorize! :edit, @user
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
  end

  # POST /staff/set_role_to_student
  def set_role_to_student 
    user = User.find_by_id params[:user_id]
    user.set_role_from_staff_to_student params[:new_deputy_id]
    redirect_to staff_index_path
  end

  # PATCH/PUT /staff/1
  # PATCH/PUT /staff/1.json
  def update
    update_from_params_for_languages params, staff_path(@user)
  end

  # DELETE /staff/1
  # DELETE /staff/1.json
  def destroy
    @user.destroy
    respond_and_redirect_to staff_index_path, 'Staff has been successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email,
        :firstname, :lastname,
        :birthday, :additional_information, :homepage,
        :github, :facebook, :xing, :photo, :cv, :linkedin, :user_status_id,
        :language_ids => [],:programming_language_ids => [])
    end

    def check_current_user_or_admin
      set_user
      unless current_user? @user or user_is_admin?
        redirect_to staff_path @user
      end
    end

    def check_user_can_index_staff
      unless user_is_admin?
        redirect_to root_path
      end
    end
end