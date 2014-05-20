class JobOffersController < ApplicationController
  include UsersHelper

  skip_before_filter :signed_in_user, only: [:index]

  load_and_authorize_resource except: [:index, :edit]
  skip_load_resource only: [:create] 

  #before_filter :new_job_offer, only: [:create]
  before_filter :check_job_is_in_editable_state, only: [:update, :edit]
  before_filter :check_new_end_date_is_valid, only: [:prolong]

  before_action :set_job_offer, only: [:show, :edit, :update, :destroy, :close, :accept, :decline, :prolong, :request_prolong, :fire]
  before_action :set_employers, only: [:index, :find_archived_jobs, :archive, :matching]

  has_scope :filter_employer, only: [:index, :archive], as: :employer
  has_scope :filter_category, only: [:index, :archive], as: :category
  has_scope :filter_graduation, only: [:index, :archive], as: :graduation
  has_scope :filter_state, only: [:index, :archive], as: :state
  has_scope :filter_start_date, only: [:index, :archive], as: :start_date
  has_scope :filter_end_date, only: [:index, :archive], as: :end_date
  has_scope :filter_time_effort, only: [:index, :archive], as: :time_effort
  has_scope :filter_compensation, only: [:index, :archive], as: :compensation
  has_scope :filter_programming_languages, type: :array, only: [:index, :archive, :matching], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index, :archive, :matching], as: :language_ids
  has_scope :search, only: [:index, :archive]

  def index
    job_offers = apply_scopes(JobOffer.active).sort(params[:sort]).paginate(page: params[:page])
    @job_offers_list = { items: job_offers, name: "job_offers.headline" }
  end

  def show
    if @job_offer.pending? && signed_in? && !user_is_staff_of_employer?(@job_offer) && !current_user.admin?
      redirect_to job_offers_path
    end

    @application = current_user.manifestation.application @job_offer if current_user.student?
    @assigned_students = @job_offer.assigned_students.paginate page: params[:page]
  end

  def new
    @job_offer = JobOffer.new
    @job_offer.responsible_user = current_user.manifestation
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
  end

  def edit
    authorize! :edit, @job_offer
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
  end

  def create
    @job_offer = JobOffer.create_and_notify job_offer_params, current_user
    if @job_offer.new_record?
      render_errors_and_action @job_offer, 'new'
    else
      respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.successfully_created'), 'show', :created
    end
  end

  def update
    if @job_offer.update job_offer_params
      respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.successfully_updated')
    else
      render_errors_and_action @job_offer, 'edit'
    end
  end

  def destroy
    @job_offer.destroy
    respond_and_redirect_to job_offers_url, I18n.t('job_offers.messages.successfully_deleted')
  end

  def archive
    job_offers = apply_scopes(JobOffer.closed).sort(params[:sort]).paginate(page: params[:page])
    @job_offers_list = { items: job_offers, name: "job_offers.archive" }
  end

  def request_prolong
    if @job_offer.immediately_prolongable
      @job_offer.prolong
    else
      # send email to admins
    end
  end

  def prolong
    @job_offer.prolong
    respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.successfully_prolonged')
  end

  def matching
    job_offers = apply_scopes(JobOffer.active).sort(params[:sort]).paginate(page: params[:page])
    @job_offers_list = { items: job_offers, name: "job_offers.matching_job_offers" }
    render "index"
  end

  def close
    if @job_offer.update status: JobStatus.closed
      JobOffersMailer.job_closed_email(@job_offer).deliver
      respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.successfully_completed')
    else
      render_errors_and_action @job_offer, 'edit'
    end
  end

  def accept
    if @job_offer.update status: JobStatus.active
      JobOffersMailer.admin_accepted_job_offer_email(@job_offer).deliver
      JobOffersMailer.inform_interested_students_immediately(@job_offer)
      redirect_to @job_offer, notice: I18n.t('job_offers.messages.successfully_opened')
    else
      render_errors_and_action @job_offer
    end
  end

  def decline
    if @job_offer.destroy
      JobOffersMailer.admin_declined_job_offer_email(@job_offer).deliver
      redirect_to job_offers_path, notice: I18n.t('job_offers.messages.successfully_deleted')
    else
      render_errors_and_action @job_offer
    end
  end

  def reopen
    old_job_offer = JobOffer.find params[:id]
    if old_job_offer.update status: JobStatus.closed
      @job_offer = JobOffer.new old_job_offer.attributes.with_indifferent_access.except(:id, :start_date, :end_date, :status_id, :assigned_students)
      @job_offer.responsible_user = current_user.manifestation
      render "new", notice: I18n.t('job_offers.messages.successfully_created')
    else
      render_errors_and_action @job_offer
    end
  end

  def fire
    student = Student.find job_offer_params[:student_id]
    @job_offer.fire student
    respond_and_redirect_to @job_offer, student.full_name + " was successfully removed from this job offer."
  end

  private
    def set_job_offer
      @job_offer = JobOffer.find params[:id]
    end

    def set_employers
      @employers = Employer.all
    end

    def rescue_from_exception(exception)
      if [:close, :edit, :destroy, :update, :decline].include?(exception.action)
        redirect_to exception.subject, notice: exception.message and return
      end
      if [:show].include?(exception.action) && @job_offer.closed?
        redirect_to archive_job_offers_path and return
      end
      redirect_to job_offers_path, notice: exception.message
    end

    def job_offer_params
      parameters = params.require(:job_offer).permit(:description, :title, :employer_id, :state_id, :category_id, :academic_program_id, :graduation_id, :room_number, :start_date, :end_date, :compensation, :flexible_start_date, :responsible_user_id, :time_effort, :student_id, :vacant_posts, { programming_language_ids: []}, {language_ids: []})

      if parameters[:compensation] == I18n.t('job_offers.default_compensation')
        parameters[:compensation] = 10.0
      end

      if parameters[:start_date] == I18n.t('job_offers.default_startdate')
        parameters[:start_date] = (Date.current + 1).to_s
        parameters[:flexible_start_date] = true
      end
      parameters
    end

    def check_job_is_in_editable_state
      set_job_offer
      unless @job_offer.editable?
        redirect_to @job_offer
      end
    end

    def check_new_end_date_is_valid
      @date = Date.parse params[:job_offer][:end_date]
    rescue ArgumentError
      respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.choose_valid_end_date')
    end
end
