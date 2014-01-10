class ApplicationsController < ApplicationController
    include UsersHelper

    before_filter :signed_in_user

    def create
        @job_offer = JobOffer.find application_params[:job_offer_id]
        if not @job_offer.open?
            flash[:error] = 'This job offer is not currently open.'
        else
          @application = Application.new(job_offer: @job_offer, user: current_user)
          if @application.save
              ApplicationsMailer.new_application_notification_email(@application).deliver
              flash[:success] = 'Applied Successfully!'
          else
              flash[:error] = 'An error occured while applying. Please try again later.'
          end 
        end
        redirect_to @job_offer
    end

    # GET accept
    def accept
      @application = Application.find params[:id]
      if @application.job_offer.update({assigned_student: @application.user, status: JobStatus.running}) and Application.where(job_offer: @application.job_offer).delete_all
        ApplicationsMailer.application_accepted_student_email(@application).deliver
        JobOffersMailer.job_student_accepted_email(@application.job_offer).deliver
        respond_and_redirect_to(@application.job_offer, 'Application was successfully accepted.')
      else
        render_errors_and_action(@application.job_offer)
      end
    end

    # GET decline
    def decline
      @application = Application.find params[:id]
      if @application.delete
        ApplicationsMailer.application_declined_student_email(@application)
        redirect_to @application.job_offer      
      else
        render_errors_and_action(@application.job_offer)
      end        
    end

    #DELETE destroy
    def destroy
      @application = Application.find params[:id]
      @application.destroy
      respond_and_redirect_to(@application.job_offer, 'Application has been successfully deleted.')
    end

    private

        def application_params
            params.require(:application).permit(:job_offer_id)
        end
end
