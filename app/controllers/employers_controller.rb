class EmployersController < ApplicationController

  skip_before_filter :signed_in_user, only: [:new, :create]

  authorize_resource only: [:edit, :update]
  before_action :set_employer, only: [:show, :edit, :update]

  def index
    @employers = Employer.all.sort_by { |employer| employer.name }
    @employers = @employers.paginate page: params[:page], per_page: 15
  end

  def show
    page = params[:page]
    @staff =  @employer.staff_members.where.not(id: @employer.deputy.id).paginate page: page
    @running_job_offers = @employer.job_offers.running.paginate page: page
    @open_job_offers = @employer.job_offers.open.paginate page: page
    @pending_job_offers = @employer.job_offers.pending.paginate page: page
  end

  def new
    @employer = Employer.new
    @employer.build_deputy
    @employer.deputy.build_user
  end

  def create
    @employer = Employer.new employer_params
    @employer.deputy.employer = @employer if @employer.deputy

    if @employer.save
      sign_in @employer.deputy.user
      respond_and_redirect_to @employer, I18n.t('employers.messages.successfully_created.'), 'show', :created
    else
      render_errors_and_action @employer, 'new'
    end
  end

  def edit
    authorize! :edit, @employer
  end

  def update
    if @employer.update employer_params
      respond_and_redirect_to @employer, I18n.t('employers.messages.successfully_updated.')
    else
      render_errors_and_action @employer, 'edit'
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
      params.require(:employer).permit(:name, :description, :avatar, :head, :deputy_id, deputy_attributes: [ user_attributes: [:firstname, :lastname, :email, :password, :password_confirmation ]])
    end
end
