class RatingsController < ApplicationController
  
  def index
    @ratings = Rating.where(employer_id: params[:employer_id])
  end
  
  def create
    @selectable_job_offers = JobOffer.where(employer_id: params[:employer_id])
    
    @rating = Rating.new(rating_params)
    @rating.student_id = current_user.manifestation_id
    @rating.employer_id = params[:employer_id]
        
    if @rating.save       
      flash[:success] = 'Rating sucessfully created' #I18n.t('users.messages.successfully_created')
      redirect_to employer_ratings_path
    else
      render_errors_and_action(@rating, 'new')
    end
  end
  
  def new
    @employer = Employer.find(params[:employer_id])
    @rating = Rating.new
    
    @selectable_job_offers = JobOffer.where(employer_id: params[:employer_id])
  end
  
  def edit
    @employer = Employer.find(params[:employer_id])
    @rating = Rating.find(params[:id])
    
    @selectable_job_offers = JobOffer.where(employer_id: params[:employer_id])
  end
  
  def update
    @rating = Rating.find(params[:id])
    
    @employer = Employer.find(params[:employer_id])
    
    if @rating.update(rating_params)
      redirect_to employer_ratings_path
    else
      redirect_to employer_ratings_path
    end
  end
  

  private
    def rating_params
      params.require(:rating).permit(:student_id, :employer_id, :job_offer_id, :score, :headline, :description)
    end
    
end  