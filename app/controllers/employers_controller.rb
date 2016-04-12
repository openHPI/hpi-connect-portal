# == Schema Information
#
# Table name: employers
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description           :text
#  created_at            :datetime
#  updated_at            :datetime
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  activated             :boolean          default(FALSE), not null
#  place_of_business     :string(255)
#  website               :string(255)
#  line_of_business      :string(255)
#  year_of_foundation    :integer
#  number_of_employees   :string(255)
#  requested_package_id  :integer          default(0), not null
#  booked_package_id     :integer          default(0), not null
#  single_jobs_requested :integer          default(0), not null
#  token                 :string(255)
#

class EmployersController < ApplicationController

  skip_before_filter :signed_in_user, only: [:index, :show, :new, :create]

  authorize_resource only: [:edit, :update, :activate, :deactivate, :destroy, :invite_colleague]
  before_action :set_employer, only: [:show, :edit, :update, :activate, :deactivate, :destroy, :invite_colleague]

  def index
    @employers = can?(:activate, Employer) ? Employer.all : Employer.active

    @premium_employers = @employers.select {|employer| employer.premium? }
    @premium_employers = @premium_employers.sort_by { |premium_employer| premium_employer.name.downcase }

    @employers = @employers.sort_by { |employer| employer.name.downcase }
    @employers = @employers.paginate page: params[:page], per_page: 15
  end

  def show
    not_found unless @employer.activated || can?(:activate, @employer) || !current_user || (current_user && (current_user.staff? && current_user.manifestation.employer == @employer))
    page = params[:page]
    @staff =  @employer.staff_members.paginate page: page
    @active_job_offers = @employer.job_offers.active.paginate page: page
    @pending_job_offers = @employer.job_offers.pending.paginate page: page
    @closed_job_offers = @employer.job_offers.closed.paginate page: page
  end

  def new
    @employer = Employer.new
    @employer.staff_members.build
    @employer.staff_members.first.build_user
    @employer.build_contact
  end

  def create
    @employer = Employer.new employer_params
    @employer.staff_members.first.employer = @employer if @employer.staff_members.any?

    if @employer.save
      sign_in @employer.staff_members.first.user if @employer.staff_members.any?
      respond_and_redirect_to home_employers_path, I18n.t('employers.messages.successfully_created.'), 'show', :created
      EmployersMailer.new_employer_email(@employer).deliver
      EmployersMailer.registration_confirmation(@employer)
    else
      render_errors_and_action @employer, 'new'
    end
  end

  def edit
    authorize! :edit, @employer
    @employer.build_contact unless @employer.contact
  end

  def update
    old_requested_package = @employer.requested_package_id
    if @employer.update employer_params
      if @employer.requested_package_id != old_requested_package
        EmployersMailer.book_package_email(@employer).deliver
        EmployersMailer.requested_package_confirmation_email(@employer).deliver
      end
      respond_and_redirect_to @employer, I18n.t('employers.messages.successfully_updated.')
    else
      render_errors_and_action @employer, 'edit'
    end
  end

  def invite_colleague
    colleage_mail = params[:invite_colleague_email][:colleague_email]
    first_name = params[:invite_colleague_email][:first_name]
    last_name = params[:invite_colleague_email][:last_name]
    receiver_name = first_name + " " + last_name
    if colleage_mail.empty?
      redirect_to(employer_path(@employer), notice: I18n.t('employers.messages.invalid_colleague_email')) and return
    end
    @employer.invite_colleague(colleage_mail, receiver_name, current_user)
    respond_and_redirect_to(employer_path(@employer), I18n.t('employers.messages.colleague_successfully_invited'))
  end

  def activate
    old_booked_package_id = @employer.booked_package_id
    @employer.update_column :activated, true
    @employer.update_column :booked_package_id, @employer.requested_package_id
    EmployersMailer.booked_package_confirmation_email(@employer).deliver if old_booked_package_id != @employer.booked_package_id
    respond_and_redirect_to @employer, I18n.t('employers.messages.successfully_activated')
  end

  def deactivate
    @employer.update_column :activated, false
    @employer.update_column :booked_package_id, 0
    respond_and_redirect_to @employer, I18n.t('employers.messages.successfully_deactivated')
  end

  def destroy
    if @employer.destroy
      respond_and_redirect_to employers_path, I18n.t('employers.messages.successfully_deleted')
    else
      respond_and_redirect_to @employer, { error: I18n.t('employers.messages.unsuccessfully_deleted') }
    end
  end

  def home
  end

  private

    def rescue_from_exception(exception)
      redirect_to employers_path, notice: exception.message
    end

    def set_employer
      @employer = Employer.find params[:id]
    end

    def employer_params
      params.require(:employer).permit(:name, :description, :avatar, :number_of_employees, :year_of_foundation, :line_of_business, :website, :place_of_business, :requested_package_id, staff_members_attributes: [user_attributes: [:firstname, :lastname, :email, :password, :password_confirmation ]], contact_attributes: [:name, :street, :zip_city, :email, :phone])
    end
end
