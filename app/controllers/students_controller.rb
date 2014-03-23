class StudentsController < ApplicationController
  include UsersHelper

  skip_before_filter :signed_in_user, only: [:new, :create]

  authorize_resource except: [:destroy, :matching, :edit, :index, :request_linkedin_import, :insert_imported_data]

  before_action :set_student, only: [:show, :edit, :update, :destroy, :request_linkedin_import, :insert_imported_data]
  
  has_scope :search_students, only: [:index, :matching], as: :q
  has_scope :filter_programming_languages, type: :array, only: [:index, :matching], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index, :matching], as: :language_ids
  has_scope :filter_semester, only: [:index, :matching],  as: :semester

  def index
    authorize! :index, Student
    @students = apply_scopes(Student.all).sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: params[:page], per_page: 5)
  end

  def show
    @job_offers = @student.assigned_job_offers.paginate page: params[:page], per_page: 5
  end

  def new
    @student = Student.new
    @student.build_user
  end

  def create
    @student = Student.new student_params
    if @student.save
      sign_in @student.user
      flash[:success] = I18n.t('users.messages.successfully_created')
      redirect_to [:edit, @student]
    else
      render 'new'
    end
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

  def activate
    url = 'https://openid.hpi.uni-potsdam.de/user/' + params[:student][:username] rescue ''
    authenticate_with_open_id url do |result, identity_url|
      if result.successful?
        current_user.update_column :activated, true
        flash[:success] = 'Profile successfully activated.'
      else
        flash[:error] = 'Error during activation. Please try again later.'
      end
      redirect_to current_user.manifestation
    end
  end

  def request_linkedin_import
    authorize! :request_linkedin_import, @student
    @request_token = Student.linkedin_request_token_for_callback(insert_imported_data_student_url(@student))
    session[:rtoken] = @request_token.token
    session[:rsecret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end

  def insert_imported_data
    authorize! :request_linkedin_import, @student
    linkedin_client = Student.create_linkedin_client
    authorize_client linkedin_client
    @student.update_from_linkedin(linkedin_client)
    redirect_to edit_student_path(@student)
  end

  private
    def authorize_client(linkedin_client)
      if session[:atoken].nil?
        pin = params[:oauth_verifier]
        atoken, asecret = linkedin_client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
        session[:atoken] = atoken
        session[:asecret] = asecret
      else
        linkedin_client.authorize_from_access(session[:atoken], session[:asecret])
      end
    end

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
