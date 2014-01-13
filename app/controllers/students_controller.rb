include UsersHelper

class StudentsController < ApplicationController
  include UsersHelper
  
  before_filter :check_user_can_index_students, only: [:index]
  before_filter :check_current_user_or_admin, only: [:edit]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  has_scope :search_students, only: [:index], as: :q
  has_scope :filter_programming_languages, type: :array, only: [:index], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index], as: :language_ids
  has_scope :filter_semester, only: [:index],  as: :semester

  # GET /students
  # GET /students.json
  def index
    @users = apply_scopes(User.students).sort_by{|x| [x.lastname, x.firstname]}
    @users = @users.paginate(:page => params[:page], :per_page => 5 )
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @user = User.students.find params[:id]
  end

  # GET /students/new
  def new
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
    @user = User.new
  end

  # GET /students/1/edit
  def edit
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    update_and_remove_for_language(params[:programming_languages], params[:id], ProgrammingLanguagesUser, "programming_language_id")
    update_and_remove_for_language(params[:languages], params[:id], LanguagesUser, "language_id")

    if @user.update(user_params)
      respond_and_redirect_to(student_path(@user), 'User was successfully updated.')
    else
      render_errors_and_action(student_path(@user), 'edit')
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @user.destroy
    respond_and_redirect_to(students_url, 'Student has been successfully deleted.')
  end

  # GET /students/matching
  def matching 
    #XXX should be a list of strings not [string]
    @users = User.search_students_by_language_and_programming_language(
      params[:languages], params[:programming_languages])
    @users = @users.paginate(:page => params[:page], :per_page => 10 )
    render "index"
  end

  def update_role
    role_name = params[:role_name]
    chair_name = params[:chair_name]

    if chair_name
      chair = Chair.find_by_name(chair_name)
    else
      chair = current_user.chair
    end

    case role_name
      when "Deputy"
        promote_to_deputy(params[:student_id], chair)
      when Role.find_by_level(3).name
        promote_to_admin(params[:student_id])
      when Role.find_by_level(2).name
        promote_to_research_assistant(params[:student_id], chair)
    end
    redirect_to(students_path)
  end

  def promote_to_deputy(student_id, chair)
    chair.update(:deputy_id => student_id)
    User.find(student_id).update(:chair => chair, :role => Role.find_by_level(2))
  end

  def promote_to_admin(student_id)
    student = User.find(student_id)
    student.update(:role => Role.find_by_level(3))
  end

  def promote_to_research_assistant(student_id, chair)
    student = User.find(student_id)
    student.update(:role => Role.find_by_level(2), :chair => chair)
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
        :firstname, :lastname, :semester, :academic_program,
        :birthday, :education, :additional_information, :homepage,
        :github, :facebook, :xing, :photo, :cv, :linkedin, :user_status_id)
    end

    def check_current_user_or_admin
      set_user
      unless current_user? @user or user_is_admin?
        redirect_to student_path(@user)
      end
    end

    def check_user_can_index_students
      unless user_is_admin? || user_is_staff?
        redirect_to root_path
      end
    end
end