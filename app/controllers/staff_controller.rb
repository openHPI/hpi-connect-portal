class StaffController < ApplicationController
  include UsersHelper

  before_filter :check_user_can_index_staff, only: [:index]
  before_filter :check_current_user_or_admin, only: [:edit]

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /staff
  # GET /staff.json
  def index
    @users = User.staff
    @users = @users.paginate(:page => params[:page], :per_page => 5 )
  end

  # GET /staff/1
  # GET /staff/1.json
  def show
    @user = User.staff.find params[:id]
  end

  # GET /staff/new
  def new
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
    @user = User.new
  end

  # GET /staff/1/edit
  def edit
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
  end

  # PATCH/PUT /staff/1
  # PATCH/PUT /staff/1.json
  def update
    update_and_remove_for_language(params[:programming_languages], params[:id], ProgrammingLanguagesUser, "programming_language_id")
    update_and_remove_for_language(params[:languages], params[:id], LanguagesUser, "language_id")

    if @user.update(user_params)
      respond_and_redirect_to(staff_path(@user), 'User was successfully updated.')
    else
      render_errors_and_action(staff_path(@user), 'edit')
    end
  end

  # DELETE /staff/1
  # DELETE /staff/1.json
  def destroy
    @user.destroy
    respond_and_redirect_to(staff_index_path, 'Staff has been successfully deleted.')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
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
        redirect_to staff_path(@user)
      end
    end

    def check_user_can_index_staff
      unless user_is_admin?
        redirect_to root_path
      end
    end
end