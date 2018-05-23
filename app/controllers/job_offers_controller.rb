# == Schema Information
#
# Table name: job_offers
#
#  id                        :integer          not null, primary key
#  description               :text
#  title                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  start_date                :date
#  end_date                  :date
#  time_effort               :float
#  compensation              :float
#  employer_id               :integer
#  status_id                 :integer
#  flexible_start_date       :boolean          default(FALSE)
#  category_id               :integer          default(0), not null
#  state_id                  :integer          default(3), not null
#  graduation_id             :integer          default(2), not null
#  prolong_requested         :boolean          default(FALSE)
#  prolonged                 :boolean          default(FALSE)
#  prolonged_at              :datetime
#  release_date              :date
#  offer_as_pdf_file_name    :string(255)
#  offer_as_pdf_content_type :string(255)
#  offer_as_pdf_file_size    :integer
#  offer_as_pdf_updated_at   :datetime
#  student_group_id          :integer          default(0), not null
#

class JobOffersController < ApplicationController
  include UsersHelper

  skip_before_filter :signed_in_user, only: [:index]

  load_and_authorize_resource except: [:index, :edit]
  skip_load_resource only: [:create]

  #before_filter :new_job_offer, only: [:create]
  before_filter :check_job_is_in_editable_state, only: [:update, :edit]

  before_action :set_job_offer, only: [:show, :edit, :update, :destroy, :close, :accept, :decline, :prolong, :request_prolong]
  before_action :set_employers, only: [:index, :find_archived_jobs, :archive, :matching]

  has_scope :active, only: [:index], type: :boolean, default: true, unless: -> controller { controller.signed_in_admin? && !controller.params[:pending].nil? }
  has_scope :pending, only: [:index], type: :boolean, if: :signed_in_admin?
  has_scope :filter_employer, only: [:index, :archive], as: :employer
  has_scope :filter_category, only: [:index, :archive], as: :category
  has_scope :filter_graduation, only: [:index, :archive], as: :graduation
  has_scope :filter_state, only: [:index, :archive], as: :state
  has_scope :filter_student_group, only: [:index, :archive], as: :student_group
  has_scope :filter_start_date, only: [:index, :archive], as: :start_date
  has_scope :filter_end_date, only: [:index, :archive], as: :end_date
  has_scope :filter_time_effort, only: [:index, :archive], as: :time_effort
  has_scope :filter_compensation, only: [:index, :archive], as: :compensation
  has_scope :filter_programming_languages, type: :array, only: [:index, :archive, :matching], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index, :archive, :matching], as: :language_ids
  has_scope :search, only: [:index, :archive]

  def index
    if params[:commit] == I18n.t("job_offers.create_as_newsletter")
      apply_scopes(JobOffer.active) # to fill current_scopes
      redirect_to new_newsletter_order_path({ newsletter_params: current_scopes })
    end

    @job_offers = JobOffer.sort(apply_scopes(JobOffer).all, params[:sort]).paginate(page: params[:page])
  end

  def show
    if @job_offer.pending? && signed_in? && !user_is_staff_of_employer?(@job_offer) && !current_user.admin?
      redirect_to job_offers_path
    end
  end

  def new
    @job_offer = JobOffer.new
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
    @job_offer.build_contact
  end

  def edit
    authorize! :edit, @job_offer
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
    @job_offer.build_contact unless @job_offer.contact
  end

  def create
    @job_offer = JobOffer.create_and_notify job_offer_params, current_user
    if @job_offer.new_record?
      render_errors_and_action @job_offer, 'new'
    else
      if !@job_offer.employer.contact.nil? && params[:job_offer][:copy_to_employer_contact] == "true"
        @job_offer.employer.contact.update contact_params
      end

      respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.successfully_created'), 'show', :created
    end
  end

  def update
    if @job_offer.update job_offer_params
      if !@job_offer.employer.contact.nil? && params[:job_offer][:copy_to_employer_contact] == "true"
        @job_offer.employer.contact.update contact_params
      end

      respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.successfully_updated')
    else
      render_errors_and_action @job_offer, 'edit'
    end
  end

  def destroy
    @job_offer.destroy
    respond_and_redirect_to job_offers_url, I18n.t('job_offers.messages.successfully_deleted')
  end

  def archive
    @job_offers = JobOffer.sort(apply_scopes(JobOffer.closed), params[:sort]).paginate(page: params[:page])
  end

  def request_prolong
    @job_offer.update_column :prolong_requested, true
    message = I18n.t('job_offers.messages.successfully_prolong_requested')
    JobOffersMailer.prolong_requested_email(@job_offer).deliver_now
    respond_and_redirect_to @job_offer, message
  end

  def prolong
    @job_offer.prolong
    respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.successfully_prolonged')
  end

  def matching
    @job_offers = JobOffer.sort(apply_scopes(JobOffer.active), params[:sort]).paginate(page: params[:page])
    render "index"
  end

  def close
    if @job_offer.update status: JobStatus.closed
      JobOffersMailer.job_closed_email(@job_offer).deliver_now
      respond_and_redirect_to @job_offer, I18n.t('job_offers.messages.successfully_completed')
    else
      render_errors_and_action @job_offer, 'edit'
    end
  end

  def accept
    if @job_offer.update status: JobStatus.active, release_date: Date.current

      @job_offer.employer.staff_members.each do |staff|
        JobOffersMailer.admin_accepted_job_offer_email(@job_offer, staff).deliver_now
      end

      if(!@job_offer.employer.can_create_job_offer?(@job_offer.category))
        @job_offer.employer.remove_one_single_booked_job
      end

      redirect_to @job_offer, notice: I18n.t('job_offers.messages.successfully_opened')
    else
      render_errors_and_action @job_offer
    end
  end

  def decline
    if @job_offer.destroy
      @job_offer.employer.staff_members.each do |staff|
        JobOffersMailer.admin_declined_job_offer_email(@job_offer, staff).deliver_now
      end

      if(!@job_offer.employer.can_create_job_offer?(@job_offer.category))
        @job_offer.employer.remove_one_single_booked_job
      end

      redirect_to job_offers_path, notice: I18n.t('job_offers.messages.successfully_deleted')
    else
      render_errors_and_action @job_offer
    end
  end

  def reopen
    old_job_offer = JobOffer.find params[:id]
    if old_job_offer.update status: JobStatus.closed
      copied_attr = ["description_de", "description_en", "title", "time_effort", "compensation", "employer_id", "category_id", "graduation_id", "student_group_id"]
      copied_contact_attr = ["name", "street", "zip_city", "email", "phone"]
      @job_offer = JobOffer.new old_job_offer.attributes.slice(*copied_attr)
      @job_offer.contact = Contact.new old_job_offer.contact.attributes.slice(*copied_contact_attr)
      render "new", notice: I18n.t('job_offers.messages.successfully_created')
    else
      render_errors_and_action @job_offer
    end
  end

  def export
    send_data JobOffer.export_active_jobs, filename: "Stellenangebote-#{Date.today}.csv", type: 'text/csv'
  end

  private
    def set_job_offer
      @job_offer = JobOffer.find params[:id]
    end

    def set_employers
      @employers = Employer.all
    end

    def rescue_from_exception(exception)
      if [:close, :edit, :destroy, :update, :decline].include?(exception.action)
        redirect_to exception.subject, notice: exception.message and return
      end
      if [:show].include?(exception.action) && @job_offer.closed?
        redirect_to archive_job_offers_path and return
      end
      redirect_to job_offers_path, notice: exception.message
    end

    def job_offer_params
      parameters = params.require(:job_offer).permit(JobOffer.locale_columns(:description), :title, :offer_as_pdf, :employer_id, :state_id, :category_id, :student_group_id, :graduation_id, :start_date, :end_date, :compensation, :flexible_start_date, :time_effort, :student_id, { programming_language_ids: []}, {language_ids: []}, contact_attributes: [:name, :street, :zip_city, :email, :phone, :company])

      if parameters[:compensation] == I18n.t('job_offers.default_compensation')
        parameters[:compensation] = 10.0
      end

      if parameters[:start_date] == I18n.t('job_offers.default_startdate')
        parameters[:start_date] = (Date.current + 1).to_s
        parameters[:flexible_start_date] = true
      end
      parameters
    end

    def contact_params
      job_offer_params[:contact_attributes]
    end

    def check_job_is_in_editable_state
      set_job_offer
      unless @job_offer.editable?
        redirect_to @job_offer
      end
    end
end
