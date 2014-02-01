class StudentsController < ApplicationController
  include UsersHelper

  authorize_resource class: "User", except: [:update_role, :destroy, :matching]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  has_scope :search_students, only: [:index, :matching], as: :q
  has_scope :filter_programming_languages, type: :array, only: [:index, :matching], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index, :matching], as: :language_ids
  has_scope :filter_semester, only: [:index, :matching],  as: :semester

  rescue_from CanCan::AccessDenied do |exception|
    if [:index].include? exception.action
      respond_and_redirect_to root_path, exception.message
    elsif [:edit, :update_role, :destroy, :promote, :update].include? exception.action
      respond_and_redirect_to student_path(exception.subject), exception.message
    else
      respond_and_redirect_to students_path, exception.message
    end
  end

  # GET /students
  # GET /students.json
  def index
    @users = apply_scopes(User.students).sort_by{|user| [user.lastname, user.firstname] }.paginate(page: params[:page], per_page: 5)
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @user = User.find params[:id]
    redirect_to user_path @user unless @user.student?
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
    authorize! :destroy, @user
    @user.destroy
    respond_and_redirect_to(students_url, 'Student has been successfully deleted.')
  end

  # GET /students/matching
  def matching
    #XXX should be a list of strings not [string]
    authorize! :read, User
    @users = apply_scopes(User.students).sort_by{|x| [x.lastname, x.firstname]}
    @users = @users.paginate(:page => params[:page], :per_page => 5 )
    render "index"
  end

  # POST /students/update_role

  def update_role
    @employer = params[:employer_id] ? Employer.find(params[:employer_id]) : current_user.employer
    student = User.find(params[:student_id])

    authorize! :promote, student
    authorize! :update, @employer if params[:role_level].to_i == 4

    student.set_role(params[:role_level].to_i, @employer)
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
end