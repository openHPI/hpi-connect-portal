class EmployersController < ApplicationController

  skip_before_filter :signed_in_user, only: [:index, :show, :new, :create]

  authorize_resource only: [:edit, :update, :activate, :deactivate, :destroy]
  before_action :set_employer, only: [:show, :edit, :update, :activate, :deactivate, :destroy]

  def index
    @employers = can?(:activate, Employer) ? Employer.all : Employer.active
    @employers = @employers.sort_by { |employer| employer.name }
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
  end

  def create
    @employer = Employer.new employer_params
    @employer.staff_members.first.employer = @employer if @employer.staff_members.any?

    if @employer.save
      sign_in @employer.staff_members.first.user if @employer.staff_members.any?
      respond_and_redirect_to home_employers_path, I18n.t('employers.messages.successfully_created.'), 'show', :created
      EmployersMailer.new_employer_email(@employer).deliver
    else
      render_errors_and_action @employer, 'new'
    end
  end

  def edit
    authorize! :edit, @employer
  end

  def update
    old_requested_package = @employer.requested_package_id
    if @employer.update employer_params
      EmployersMailer.book_package_email(@employer).deliver if @employer.requested_package_id > old_requested_package
      respond_and_redirect_to @employer, I18n.t('employers.messages.successfully_updated.')
    else
      render_errors_and_action @employer, 'edit'
    end
  end

  def activate
    @employer.update_column :activated, true
    @employer.update_column :booked_package_id, @employer.requested_package_id
    flash[:success] = I18n.t('employers.messages.successfully_activated')
    redirect_to @employer
  end

  def deactivate
    @employer.update_column :activated, false
    @employer.update_column :booked_package_id, 0
    flash[:success] = I18n.t('employers.messages.successfully_deactivated')
    redirect_to @employer
  end

  def destroy
    if @employer.destroy
      respond_and_redirect_to employers_path, I18n.t('employers.messages.successfully_deleted')
    else
      respond_and_redirect_to employer_path(@employer), I18n.t('employers.messages.unsuccessfully_deleted')
    end
  end

  def home

  end

  def respond_and_redirect_to(url, notice = nil, action = nil, status = nil)
    respond_to do |format|
      format.html { redirect_to url, flash: (notice.is_a?(Hash) ? notice : {success: notice})}
      if action && status
        format.json { render action: action, status: status, location: object }
      end
    end
  end

  private

    def rescue_from_exception(exception)
      redirect_to employers_path, notice: exception.message
    end

    def set_employer
      @employer = Employer.find params[:id]
    end

    def employer_params
      params.require(:employer).permit(:name, :description, :avatar, :number_of_employees, :year_of_foundation, :line_of_business, :website, :place_of_business, :requested_package_id, staff_members_attributes: [user_attributes: [:firstname, :lastname, :email, :password, :password_confirmation ]])
    end
end
