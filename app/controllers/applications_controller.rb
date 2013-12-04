class ApplicationsController < ApplicationController
    before_filter :signed_in_user

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

    private

        def application_params
            params.require(:application).permit(:job_offer_id)
        end
end
