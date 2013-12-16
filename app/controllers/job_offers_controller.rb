class JobOffersController < ApplicationController
  include UsersHelper
  include ApplicationHelper
  before_filter :check_user_is_responsible, only: [:edit, :update]
  before_filter :check_user_is_research_assistant_of_chair, only: [:complete]
  before_filter :check_user_is_deputy, only: [:accept, :decline]
  before_action :set_job_offer, only: [:show, :edit, :update, :destroy, :complete, :accept, :decline]
  before_action :set_chairs, only: [:index, :find_jobs, :archive]

  # GET /job_offers
  # GET /job_offers.json
  def index
    job_offers = JobOffer.filter_status(JobStatus.open)
    job_offers = job_offers.sort("date")
    job_offers = job_offers.paginate(:page => params[:page])
    @job_offers_list = [{:items => job_offers, 
                        :name => "job_offers.headline"}]
    @chairs = Chair.all
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
    respond_to do |format|
      if @job_offer.save
        JobOffersMailer.new_job_offer_email(@job_offer).deliver
        format.html { redirect_to @job_offer, notice: 'Job offer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @job_offer }
      else
        render_errors_and_redirect_to(@job_offer, 'new', format)
      end
    end

  end

  # PATCH/PUT /job_offers/1
  # PATCH/PUT /job_offers/1.json
  def update
    respond_to do |format|
      if @job_offer.update(job_offer_params)
        format.html { redirect_to @job_offer, notice: 'Job offer was successfully updated.' }
        format.json { head :no_content }
      else
        render_errors_and_redirect_to(@job_offer, 'edit', format)
      end
    end
  end

  # DELETE /job_offers/1
  # DELETE /job_offers/1.json
  def destroy
    @job_offer.destroy
    respond_to do |format|
      format.html { redirect_to job_offers_url }
      format.json { head :no_content }
    end
  end

  # GET /job_offers/archive
  def archive
    @job_offers = JobOffer.where(:status_id => JobStatus.completed)
    @radio_button_sort_value = {"date" => false, "chair" => false}
    job_offers = @job_offers.paginate(:page => params[:page])
    @job_offers_list = [{:items => job_offers, 
                        :name => "job_offers.archive"}]
    @chairs = Chair.all
  end


  def find

    @radio_button_sort_value = {"date" => false, "chair" => false}
    job_offers = find_jobs_in_job_list(JobOffer.filter_status(JobStatus.open)) 
    job_offers = job_offers.paginate(:page => params[:page])
	  @job_offers_list = [{:items => job_offers, 
                        :name => "job_offers.headline"}]
    @chairs = Chair.all
    render "index"


  end

  def find_archived_jobs
    job_offers = find_jobs_in_job_list(JobOffer.filter(status: JobStatus.completed))
    job_offers = job_offers.paginate(:page => params[:page])
	@job_offers_list = [{:items => job_offers, 
                        :name => "job_offers.headline"}]
    @chairs = Chair.all
    render "archive"
  end

  # GET /job_offer/:id/complete
  def complete
    respond_to do |format|
      if @job_offer.update(status: JobStatus.completed)
        JobOffersMailer.job_closed_email(@job_offer).deliver
        format.html { redirect_to @job_offer, notice: 'Job offer was successfully marked as completed.' }
        format.json { head :no_content }
      else
        render_errors_and_redirect_to(@job_offer, 'edit', format)
      end
    end
  end

  # GET /job_offer/:id/accept
  def accept  
    if @job_offer.update(status: JobStatus.open )
      JobOffersMailer.deputy_accepted_job_offer_email(@job_offer).deliver
      redirect_to @job_offer, notice: 'Job offer was successfully opened.'
    else
      render_errors_and_redirect_to(@job_offer, format)
    end
  end

  # GET /job_offer/:id/decline
  def decline 
    if @job_offer.destroy
      JobOffersMailer.deputy_declined_job_offer_email(@job_offer).deliver
      redirect_to job_offers_path, notice: 'Job offer was deleted.'
    else
      render_errors_and_redirect_to(@job_offer, format)
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_offer_params
      params.require(:job_offer).permit(:description, :title, :chair_id, :room_number, :start_date, :end_date, :compensation, :time_effort, {:programming_language_ids => []},
        {:language_ids => []})
    end
    
    def render_errors_and_redirect_to(object, target, format)
      format.html { render action: target }
      format.json { render json: object.errors, status: :unprocessable_entity }
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
