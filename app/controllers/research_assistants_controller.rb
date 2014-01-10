class ResearchAssistantsController < ApplicationController
  include UsersHelper

  before_filter :check_current_user_or_admin, only: [:edit]
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
    user = User.find(params[:id])
    if user.research_assistant?
      @user = user
    else
      not_found
    end
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

  # POST /research_assistants
  # POST /research_assistants.json
  # def create
  #  @research_assistant = ResearchAssistant.new(research_assistant_params)

  #  respond_to do |format|
  #    if @research_assistant.save
  #      format.html { redirect_to @research_assistant, notice: 'Research assistant was successfully created.' }
  #      format.json { render action: 'show', status: :created, location: @research_assistant }
  #    else
  #      format.html { render action: 'new' }
  #      format.json { render json: @research_assistant.errors, status: :unprocessable_entity }
  #    end
  #  end
  # end

  # PATCH/PUT /research_assistants/1
  # PATCH/PUT /research_assistants/1.json
  def update
    update_and_remove_for_language(params[:programming_languages], params[:id], ProgrammingLanguagesUser, "programming_language_id")
    update_and_remove_for_language(params[:languages], params[:id], LanguagesUser, "language_id")

    if @user.update(user_params)
      respond_and_redirect_to(research_assistant_path(@user), 'User was successfully updated.')
    else
      render_errors_and_redirect_to(research_assistant_path(@user), 'edit')
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
        :github, :facebook, :xing, :photo, :cv, :linkedin, :status,
        :language_ids => [],:programming_language_ids => [])
    end

    def update_and_remove_for_language(params, user_id, language_class, language_id_attribute)
      if params
        params.each do |id, skill|
          l = language_class.where(:user_id => user_id, language_id_attribute.to_sym => id).first_or_create
          l.update_attributes(:skill => skill)
        end

        remove_for_language(params, user_id, language_class, language_id_attribute)
      else
        #If the User deselects all languages, they have to be destroyed
        language_class.destroy_all(:user_id => user_id)
      end
    end

    def remove_for_language(params, user_id, language_class, language_id_attribute)
      #Delete all programming languages which have been deselected (rating removed) from the form
      language_class.where(:user_id => user_id).each do |l|
        if params[l.attributes[language_id_attribute].to_s].nil?
          l.destroy
        end
      end
    end

    def check_current_user_or_admin
      set_user
      unless current_user? @user or user_is_admin?
        redirect_to research_assistant_path(@user)
      end
    end

end