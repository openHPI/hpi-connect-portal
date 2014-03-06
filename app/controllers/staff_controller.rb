class StaffController < ApplicationController
  include UsersHelper

  authorize_resource class: "User"

  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
    unless @user.staff?
      redirect_to user_path @user
    end
  end

  # GET /staff/1/edit
  def edit
    authorize! :edit, @user
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
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
    respond_and_redirect_to staff_index_path, I18n.t('users.messages.successfully_deleted.')
  end

  private

    def rescue_from_exception(exception)
      if [:index].include? exception.action
        respond_and_redirect_to root_path, exception.message
      elsif [:edit].include? exception.action
        respond_and_redirect_to exception.subject, exception.message
      else
        respond_and_redirect_to staff_index_path, exception.message
      end
    end

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
end