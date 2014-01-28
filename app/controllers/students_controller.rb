class StudentsController < ApplicationController
  include UsersHelper

  before_filter :check_user_can_index_students, only: [:index]
  before_filter :check_current_user_or_admin, only: [:edit]
  before_filter :check_user_deputy_or_admin, only: [:update_role]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  has_scope :search_students, only: [:index], as: :q
  has_scope :filter_programming_languages, type: :array, only: [:index], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index], as: :language_ids
  has_scope :filter_semester, only: [:index],  as: :semester

  # GET /students
  # GET /students.json
  def index
    @users = apply_scopes(User.students).sort_by{|user| [user.lastname, user.firstname]}.paginate(:page => params[:page], :per_page => 5 )
  end

  # GET /students/1
  # GET /students/1.json
  def show
    user = User.students.find(params[:id])
    @user = user
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
    update_from_params_for_languages(params, student_path(@user))
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

  # POST /students/update_role

  def update_role
    role_name = params[:role_name]

    @user = User.find_by_id(params[:student_id])

    new_role = nil
    should_be_deputy = false
    case role_name
      when "Deputy"
        new_role = Role.find_by_name("Staff")
        should_be_deputy = true
      when "Admin"
        new_role = Role.find_by_name("Admin")
      when "Staff"
        new_role = Role.find_by_name("Staff")
      else
        render_errors_and_action(student_path(@user))
        return
    end

    @user.promote(new_role, @employer, should_be_deputy)
    redirect_to(students_path)
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

    def check_user_deputy_or_admin
      user = User.find_by_id(params[:student_id])
      @employer = params[:employer_name] ? Employer.find_by_name(params[:employer_name]) : current_user.employer

      unless current_user.admin? || @employer.nil? || @employer.deputy == current_user
        redirect_to(student_path(user))
      end
    end
end