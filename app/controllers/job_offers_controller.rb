class JobOffersController < ApplicationController
  include UsersHelper
  include ApplicationHelper
  before_filter :check_user_is_responsible, only: [:edit, :update, :destroy]
  before_filter :check_user_is_research_assistant_of_chair, only: [:complete, :reopen]
  before_filter :check_user_is_deputy, only: [:accept, :decline]
  before_action :set_job_offer, only: [:show, :edit, :update, :destroy, :complete, :accept, :decline]
  before_action :set_chairs, only: [:index, :find_archived_jobs, :archive]

  has_scope :filter_chair, only: [:index, :archive], as: :chair
  has_scope :filter_start_date, only: [:index, :archive], as: :start_date
  has_scope :filter_end_date, only: [:index, :archive], as: :end_date
  has_scope :filter_time_effort, only: [:index, :archive], as: :time_effort
  has_scope :filter_compensation, only: [:index, :archive], as: :compensation
  has_scope :filter_programming_languages, type: :array, only: [:index, :archive], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index, :archive], as: :language_ids
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
    if @job_offer.pending? and signed_in? and !user_is_research_assistant_of_chair?(@job_offer)
      redirect_to job_offers_path
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
    @job_offer = JobOffer.new(job_offer_params, status: JobStatus.pending)
    @job_offer.responsible_user = current_user
    
    if @job_offer.save
      JobOffersMailer.new_job_offer_email(@job_offer).deliver
      respond_and_redirect_to(@job_offer, 'Job offer was successfully created.', 'show', :created)
    else
      render_errors_and_redirect_to(@job_offer, 'new')
    end
  end

  # PATCH/PUT /job_offers/1
  # PATCH/PUT /job_offers/1.json
  def update
    if @job_offer.update(job_offer_params)
      respond_and_redirect_to(@job_offer, 'Job offer was successfully updated.')
    else
      render_errors_and_redirect_to(@job_offer, 'edit')
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

  # GET /job_offer/:id/complete
  def complete
    if @job_offer.update(status: JobStatus.completed)
      JobOffersMailer.job_closed_email(@job_offer).deliver
      respond_and_redirect_to(@job_offer, 'Job offer was successfully marked as completed.')
    else
      render_errors_and_redirect_to(@job_offer, 'edit')
    end
  end

  # GET /job_offer/:id/accept
  def accept  
    if @job_offer.update(status: JobStatus.open)
      JobOffersMailer.deputy_accepted_job_offer_email(@job_offer).deliver
      redirect_to @job_offer, notice: 'Job offer was successfully opened.'
    else
      render_errors_and_redirect_to(@job_offer)
    end
  end

  # GET /job_offer/:id/decline
  def decline 
    if @job_offer.destroy
      JobOffersMailer.deputy_declined_job_offer_email(@job_offer).deliver
      redirect_to job_offers_path, notice: 'Job offer was deleted.'
    else
      render_errors_and_redirect_to(@job_offer)
    end
  end 

  # GET /job_offer/:id/reopen
  def reopen 
    old_job_offer = JobOffer.find params[:id]
    if old_job_offer.update(status: JobStatus.completed)
      @job_offer = JobOffer.new(old_job_offer.attributes.with_indifferent_access.except(:id, :start_date, :end_date, :assigned_student_id, :status_id))
      @job_offer.responsible_user = current_user
      render "new", notice: 'New job offer was created.'  
    else
      render_errors_and_redirect_to(@job_offer)
    end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_offer
      @job_offer = JobOffer.find params[:id]
    end

    def set_chairs
      @chairs = Chair.all
    end

    def job_offer_params
      params.require(:job_offer).permit(:description, :title, :chair_id, :room_number, :start_date, :end_date, :compensation, :time_effort, {:programming_language_ids => []},
        {:language_ids => []})
    end 

    def check_user_is_responsible      
      set_job_offer
      unless current_user == @job_offer.responsible_user or current_user == @job_offer.chair.deputy
        redirect_to @job_offer
      end
    end

    def check_user_is_research_assistant_of_chair    
      set_job_offer
      unless user_is_research_assistant_of_chair? @job_offer
        redirect_to @job_offer
      end
    end

    def check_user_is_deputy
      set_job_offer
      unless @job_offer.chair.deputy == current_user
        if user_is_research_assistant_of_chair? @job_offer
          redirect_to @job_offer 
        else
          redirect_to job_offers_path
        end
      end
    end
end
