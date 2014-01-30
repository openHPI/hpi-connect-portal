class JobOffersController < ApplicationController
  include UsersHelper

  before_filter :check_user_can_create_jobs, only: [:new]
  before_filter :check_user_is_responsible_or_admin, only: [:edit, :update, :destroy, :prolong]
  before_filter :check_job_is_in_editable_state, only: [:update, :edit]
  before_filter :check_user_is_staff_of_employer_or_admin, only: [:complete, :reopen]
  before_filter :check_user_is_deputy_or_admin, only: [:accept, :decline]
  before_filter :check_job_is_in_deletable_state, only: [:destroy]
  before_filter :check_new_end_date_is_valid, only: [:prolong]

  before_action :set_job_offer, only: [:show, :edit, :update, :destroy, :complete, :accept, :decline, :prolong]
  before_action :set_employers, only: [:index, :find_archived_jobs, :archive, :matching]

  has_scope :filter_employer, only: [:index, :archive], as: :employer
  has_scope :filter_start_date, only: [:index, :archive], as: :start_date
  has_scope :filter_end_date, only: [:index, :archive], as: :end_date
  has_scope :filter_time_effort, only: [:index, :archive], as: :time_effort
  has_scope :filter_compensation, only: [:index, :archive], as: :compensation
  has_scope :filter_programming_languages, type: :array, only: [:index, :archive, :matching], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index, :archive, :matching], as: :language_ids
  has_scope :filter_external_employer_only, only: [:index, :archive], as: :external_only
  has_scope :search, only: [:index, :archive]

  # GET /job_offers
  # GET /job_offers.json
  def index
    job_offers = apply_scopes(JobOffer.open).sort(params[:sort]).paginate(:page => params[:page])
    @job_offers_list = { :items => job_offers, :name => "job_offers.headline" }
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show
    if @job_offer.pending? and signed_in? and (!user_is_staff_of_employer?(@job_offer) and !user_is_admin?)
      redirect_to job_offers_path
    end

    if signed_in?
      @application = current_user.applied? @job_offer
      @assigned_students = @job_offer.assigned_students.paginate(:page => params[:page])
    end
  end

  # GET /job_offers/new
  def new
    @job_offer = JobOffer.new
    @job_offer.responsible_user = current_user
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
  end

  # GET /job_offers/1/edit
  def edit
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
  end

  # POST /job_offers
  # POST /job_offers.json
  def create
    parameters = job_offer_params

    @job_offer = JobOffer.new(parameters, status: JobStatus.pending)
    @job_offer.responsible_user = current_user
    if !parameters[:employer_id]
      @job_offer.employer = current_user.employer
    end

    if @job_offer.save
      JobOffersMailer.new_job_offer_email(@job_offer).deliver
      JobOffersMailer.inform_interested_students_immediately(@job_offer)
      respond_and_redirect_to(@job_offer, 'Job offer was successfully created.', 'show', :created)
    else
      if parameters[:flexible_start_date]
        @job_offer.flexible_start_date = true
      end
      render_errors_and_action(@job_offer, 'new')
    end
  end

  # PATCH/PUT /job_offers/1
  # PATCH/PUT /job_offers/1.json
  def update
    if @job_offer.update(job_offer_params)
      respond_and_redirect_to(@job_offer, 'Job offer was successfully updated.')
    else
      render_errors_and_action(@job_offer, 'edit')
    end
  end

  # DELETE /job_offers/1
  # DELETE /job_offers/1.json
  def destroy
    @job_offer.destroy
    respond_and_redirect_to(job_offers_url, 'Job offer has been successfully deleted.')
  end

  # GET /job_offers/archive
  def archive
    job_offers = apply_scopes(JobOffer.completed).sort(params[:sort]).paginate(:page => params[:page])
    @job_offers_list = {:items => job_offers, :name => "job_offers.archive"}
  end

  # GET /job_offer/:id/prolong
  def prolong
    date = Date.parse(params[:job_offer][:end_date])
    if @job_offer.end_date < date
      @job_offer.update_column :end_date, date
      flash[:success] = 'Job offer successfully prolonged'
      JobOffersMailer.job_prolonged_email(@job_offer).deliver
    else
      flash[:error] = 'You can only prolong the job offer.'
    end
    redirect_to @job_offer
  end

  # GET /job_offers/matching
  def matching
    job_offers = apply_scopes(JobOffer.open).sort(params[:sort]).paginate(:page => params[:page])
    @job_offers_list = {:items => job_offers, :name => "job_offers.matching_job_offers"}
    render "index"
  end

  # GET /job_offer/:id/complete
  def complete
    if @job_offer.update status: JobStatus.completed
      JobOffersMailer.job_closed_email(@job_offer).deliver
      respond_and_redirect_to(@job_offer, 'Job offer was successfully marked as completed.')
    else
      render_errors_and_action(@job_offer, 'edit')
    end
  end

  # GET /job_offer/:id/accept
  def accept
    if @job_offer.update status: JobStatus.open
      JobOffersMailer.deputy_accepted_job_offer_email(@job_offer).deliver
      redirect_to @job_offer, notice: 'Job offer was successfully opened.'
    else
      render_errors_and_action(@job_offer)
    end
  end

  # GET /job_offer/:id/decline
  def decline
    if @job_offer.destroy
      JobOffersMailer.deputy_declined_job_offer_email(@job_offer).deliver
      redirect_to job_offers_path, notice: 'Job offer was deleted.'
    else
      render_errors_and_action(@job_offer)
    end
  end

  # GET /job_offer/:id/reopen
  def reopen
    old_job_offer = JobOffer.find params[:id]
    if old_job_offer.update(status: JobStatus.completed)
      @job_offer = JobOffer.new(old_job_offer.attributes.with_indifferent_access.except(:id, :start_date, :end_date, :status_id, :assigned_students))
      @job_offer.responsible_user = current_user
      render "new", notice: 'New job offer was created.'
    else
      render_errors_and_action(@job_offer)
    end
  end

  private
    def set_job_offer
      @job_offer = JobOffer.find params[:id]
    end

    def set_employers
      @employers = Employer.all
    end

    def job_offer_params
      parameters = params.require(:job_offer).permit(:description, :title, :employer_id, :room_number, :start_date, :end_date, :compensation, :responsible_user_id, :time_effort, {:programming_language_ids => []},
        {:language_ids => []})

      if parameters[:compensation] == I18n.t('job_offers.default_compensation')
        parameters[:compensation] = 10.0
      end

      if parameters[:start_date] == I18n.t('job_offers.default_startdate')
        parameters[:start_date] = (Date.current + 1).to_s
        parameters[:flexible_start_date] = true
      end

      parameters
    end

    def check_user_can_create_jobs
      unless can?(:create, JobOffer)
        redirect_to job_offers_path
      end
    end

    def check_user_is_responsible_or_admin
      set_job_offer
      unless can?(:update, @job_offer)
        redirect_to @job_offer
      end
    end

    def check_user_is_staff_of_employer_or_admin
      set_job_offer
      unless user_is_staff_of_employer?(@job_offer) || user_is_admin?
        redirect_to @job_offer
      end
    end

    def check_user_is_deputy_or_admin
      set_job_offer
      unless (@job_offer.employer.deputy == current_user) || user_is_admin?
        if user_is_staff_of_employer? @job_offer
          redirect_to @job_offer
        else
          redirect_to job_offers_path
        end
      end
    end

    def check_job_is_in_editable_state
      set_job_offer
      unless @job_offer.open? || @job_offer.pending?
        redirect_to @job_offer
      end
    end

    def check_job_is_in_deletable_state
      set_job_offer
      unless !@job_offer.running?
        respond_and_redirect_to(@job_offer, 'This job offer is currently running and therefore can\'t be deleted.')
      end
    end

    def check_new_end_date_is_valid
      begin
        date = Date.parse(params[:job_offer][:end_date])
      rescue ArgumentError
        respond_and_redirect_to(@job_offer, 'Please choose a new end date which is valid.')
      end
    end
end
