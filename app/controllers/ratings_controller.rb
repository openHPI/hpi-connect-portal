class RatingsController < ApplicationController

  before_action :set_ratings_for_index
  before_action :set_employer, only: [:new, :create, :edit, :update]
  before_action :set_job_offers_selection, only: [:new, :create, :edit, :update]
  
  load_and_authorize_resource
  skip_load_resource :only => [:create]
  
  def index
  end
  
  def new
  end
  
  def create
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
  
  def edit
  end
  
  def update
            
    if @rating.update(rating_params)
      flash[:success] = 'Rating sucessfully updated'
      redirect_to employer_ratings_path
    else
      render_errors_and_action(@rating, 'edit')      
    end
  end
  
  def destroy
    @rating.destroy
 
    redirect_to employer_ratings_path
  end
  
  private
    def rating_params
      params.require(:rating).permit(:student_id, :employer_id, :job_offer_id, :score, :headline, :description)
    end
    
    def set_ratings_for_index
      @ratings = Rating.where(employer_id: params[:employer_id])
    end
    
    def set_employer
      @employer = Employer.find(params[:employer_id])
    end
    
    def set_job_offers_selection
      @selectable_job_offers = JobOffer.where(employer_id: params[:employer_id])
    end
end  
