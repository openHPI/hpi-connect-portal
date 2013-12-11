class ApplicationsController < ApplicationController
    include UsersHelper

    before_filter :signed_in_user
    before_filter :check_user_is_research_assistant, only: [:complete]

    def create
        @job_offer = JobOffer.find application_params[:job_offer_id]
        @application = Application.new(job_offer: @job_offer, user: current_user)
        if @application.save
            flash[:success] = 'Applied Successfully!'
        else
            flash[:error] = 'An error occured while applying. Please try again later.'
        end   
        redirect_to @job_offer
    end

    # GET accept
    def accept
      @application = Application.find params[:id]
      job_offer_params = {assigned_student: @application.user, status: JobStatus.where(:name => 'working').first}
      respond_to do |format|
        if @application.job_offer.update(job_offer_params) and Application.where(job_offer: @application.job_offer).delete_all
          format.html { redirect_to @application.job_offer, notice: 'Application was successfully accepted.' }
          format.json { head :no_content }
        else
          render_errors_and_redirect_to(@application.job_offer)
        end
      end
    end

    # GET decline
    def decline
      @application = Application.find params[:id]
      if @application.delete
        redirect_to @application.job_offer      
      else
        render_errors_and_redirect_to(@application.job_offer)
      end        
    end

    private

        def application_params
            params.require(:application).permit(:job_offer_id)
        end

        def check_user_is_research_assistant
          @job_offer = JobOffer.find params[:id]

          unless user_is_research_assistant_of_chair?(@job_offer)
            redirect_to @job_offer
          end
        end
end
