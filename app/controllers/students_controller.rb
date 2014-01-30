class StudentsController < ApplicationController
  include UsersHelper

  before_filter :check_user_can_index_students, only: [:index]
  before_filter :check_current_user_or_admin, only: [:edit]
  before_filter :check_user_deputy_or_admin, only: [:update_role]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  has_scope :search_students, only: [:index, :matching], as: :q
  has_scope :filter_programming_languages, type: :array, only: [:index, :matching], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index, :matching], as: :language_ids
  has_scope :filter_semester, only: [:index, :matching],  as: :semester

  # GET /students
  # GET /students.json
  def index
    @users = apply_scopes(User.students).sort_by{|user| [user.lastname, user.firstname] }.paginate(page: params[:page], per_page: 5)
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @user = User.find params[:id]
    redirect_to user_path(@user) unless @user.student?
    @job_offers = @user.assigned_job_offers.paginate page: params[:page], per_page: 5
  end

  # GET /students/1/edit
  def edit
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
    @all_employers = Employer.all
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    update_from_params_for_languages_and_newsletters params, student_path(@user)
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
    @users = apply_scopes(User.students).sort_by{|x| [x.lastname, x.firstname]}
    @users = @users.paginate(:page => params[:page], :per_page => 5 )
    render "index"
  end

  # POST /students/update_role

  def update_role
    User.find(params[:student_id]).set_role(params[:role_level], @employer)
    redirect_to students_path
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
        :firstname, :lastname, :semester, :academic_program,
        :birthday, :education, :additional_information, :homepage,
        :github, :facebook, :xing, :photo, :cv, :linkedin, :user_status_id, :frequency)
    end

    def check_current_user_or_admin
      set_user
      unless current_user? @user or user_is_admin?
        redirect_to student_path @user
      end
    end

    def check_user_can_index_students
      unless user_is_admin? || user_is_staff?
        redirect_to root_path
      end
    end

    def check_user_deputy_or_admin
      user = User.find_by_id params[:student_id]
      @employer = params[:employer_id] ? Employer.find(params[:employer_id]) : current_user.employer
      unless can? :promote, user
        redirect_to student_path(user)
      end
    end
end