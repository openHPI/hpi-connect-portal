class JobOffersController < ApplicationController
  before_action :set_job_offer, only: [:show, :edit, :update, :destroy]

  # GET /job_offers
  # GET /job_offers.json
  def index
    @job_offers = JobOffer.order("created_at")
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show
  end

  # GET /job_offers/new
  def new
    @job_offer = JobOffer.new
  end

  # GET /job_offers/1/edit
  def edit
  end

  # POST /job_offers
  # POST /job_offers.json
  def create
    @job_offer = JobOffer.new(job_offer_params)
    respond_to do |format|
      if @job_offer.save
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_offer
      @job_offer = JobOffer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_offer_params
      params.require(:job_offer).permit(:description, :title, :chair, :start_date, :end_date, :compensation, :time_effort, {:programming_language_ids => []})
    end
    
    def render_errors_and_redirect_to(object, target, format)
      format.html { render action: target }
      format.json { render json: object.errors, status: :unprocessable_entity }
    end  
end
