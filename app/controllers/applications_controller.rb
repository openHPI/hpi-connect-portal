class ApplicationsController < ApplicationController
  include UsersHelper

  before_filter :signed_in_user

  def create
    @job_offer = JobOffer.find application_params[:job_offer_id]

    if not @job_offer.open?
      flash[:error] = 'This job offer is currently not open.'
    else
      @application = Application.new job_offer: @job_offer, user: current_user
      if @application.save
        ApplicationsMailer.new_application_notification_email(@application, params[:message], params[:add_cv], params[:attached_files]).deliver
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
    @application.accept
    respond_and_redirect_to(@application.job_offer, 'Application was successfully accepted.')
  end

  # GET decline
  def decline
    @application = Application.find params[:id]
    @application.decline
    redirect_to @application.job_offer         
  end

  # DELETE destroy
  def destroy
    @application = Application.find params[:id]
    @application.destroy
    respond_and_redirect_to @application.job_offer, 'Application has been successfully deleted.'
  end

  private

    def application_params
      params.require(:application).permit(:job_offer_id)
    end

    def file_params
      params.require(:attached_files).permit([file_attributes: :file])
    end
end
