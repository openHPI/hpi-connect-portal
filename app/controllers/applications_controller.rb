class ApplicationsController < ApplicationController
  include UsersHelper

  before_filter :check_attachment_is_valid, only: [:create]

  def create
    @job_offer = JobOffer.find application_params[:job_offer_id]

    authorize! :create, Application
    unless @job_offer.open?
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
    @job_offer = @application.job_offer

    authorize! :accept, @application

    if @job_offer.accept_application(@application) && @job_offer.check_remaining_applications
      respond_and_redirect_to @job_offer, 'Application was successfully accepted.'
    else
      render_errors_and_action @job_offer
    end
  end

  # GET decline
  def decline
    @application = Application.find params[:id]
    authorize! :decline, @application

    if @application.decline
      redirect_to @application.job_offer
    else
      render_errors_and_action @application.job_offer
    end
  end

  # DELETE destroy
  def destroy
    @application = Application.find params[:id]
    if @application.destroy
      respond_and_redirect_to @application.job_offer, 'Application has been successfully deleted.'
    else
      render_errors_and_action @application.job_offer
    end
  end

  private

    def rescue_from_exception(exception)
      redirect_to exception.subject.job_offer, notice: exception.message
    end

    def application_params
      params.require(:application).permit(:job_offer_id)
    end

    def file_params
      params.require(:attached_files).permit([file_attributes: :file])
    end

    def check_attachment_is_valid
      if params[:attached_files]
        file = file_params[:file_attributes][0][:file]
        unless file.content_type == "application/pdf"
          job_offer = JobOffer.find application_params[:job_offer_id]
          respond_and_redirect_to job_offer, "Please choose a valid attachment (PDF only)."
        end
      end
    end
end
