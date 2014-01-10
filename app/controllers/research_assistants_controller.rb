include UsersHelper

class ResearchAssistantsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /research_assistants
  # GET /research_assistants.json
  def index
    @users = User.research_assistants
    @users = @users.paginate(:page => params[:page], :per_page => 5 )
  end

  # GET /research_assistants/1
  # GET /research_assistants/1.json
  def show
    @user = User.research_assistants.find params[:id]
  end

  # GET /research_assistants/new
  def new
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
    @user = User.new
  end

  # GET /research_assistants/1/edit
  def edit
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
  end

  # PATCH/PUT /research_assistants/1
  # PATCH/PUT /research_assistants/1.json
  def update
    update_and_remove_for_language(params[:programming_languages], params[:id], ProgrammingLanguagesUser, "programming_language_id")
    update_and_remove_for_language(params[:languages], params[:id], LanguagesUser, "language_id")

    if @user.update(user_params)
      respond_and_redirect_to(research_assistant_path(@user), 'User was successfully updated.')
    else
      render_errors_and_action(research_assistant_path(@user), 'edit')
    end
  end

  # DELETE /research_assistants/1
  # DELETE /research_assistants/1.json
  def destroy
    @user.destroy
    respond_and_redirect_to(research_assistants_url, 'Research assistant has been successfully deleted.')
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

end