class StudentsController < ApplicationController
  include UsersHelper

  skip_before_filter :signed_in_user, only: [:new, :create]

  authorize_resource except: [:destroy, :matching, :edit, :index]

  before_action :set_student, only: [:show, :edit, :update, :destroy]
  
  has_scope :search_students, only: [:index, :matching], as: :q
  has_scope :filter_programming_languages, type: :array, only: [:index, :matching], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index, :matching], as: :language_ids
  has_scope :filter_semester, only: [:index, :matching],  as: :semester

  def new
    @student = Student.new
    @student.build_user
  end

  def create
    @student = Student.new student_params
    if @student.save
      sign_in @student.user
      flash[:success] = "Welcome to HPI Career!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    authorize! :index, Student
    @students = apply_scopes(Student.all).sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: params[:page], per_page: 5)
  end

  def show
    @job_offers = @student.assigned_job_offers.paginate page: params[:page], per_page: 5
  end

  def edit
    authorize! :edit, @student
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
    @employers = Employer.all
  end

  def update
    update_from_params_for_languages_and_newsletters params, student_path(@student)

    if @student.update student_params
      respond_and_redirect_to(@student, I18n.t('users.messages.successfully_updated.'))
    else
      render_errors_and_action(@student, 'edit')
    end
  end

  def destroy
    authorize! :destroy, @student
    @student.destroy
    respond_and_redirect_to(students_url, I18n.t('users.messages.successfully_deleted.'))
  end

  def matching
    authorize! :read, Student.all
    @students = Student.all.sort_by{ |x| [x.lastname, x.firstname] }
    @students = @students.paginate page: params[:page], per_page: 5
    render "index"
  end

  private

    def set_student
      @student = Student.find params[:id]
    end

    def student_params
      params.require(:student).permit(:semester, :academic_program, :education, :additional_information, :birthday, :homepage, :github, :facebook, :xing, :linkedin, :employment_status_id, :languages, :programming_languages, user_attributes: [:firstname, :lastname, :email, :password, :password_confirmation, :photo, :cv])
    end

    def rescue_from_exception(exception)
      if [:index].include? exception.action
        respond_and_redirect_to root_path, exception.message
      elsif [:edit, :destroy, :update].include? exception.action
        respond_and_redirect_to student_path(exception.subject), exception.message
      else
        respond_and_redirect_to root_path, exception.message
      end
    end
end
