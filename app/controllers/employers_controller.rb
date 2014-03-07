class EmployersController < ApplicationController

  load_and_authorize_resource only: [:new, :edit, :update, :create]
  before_action :set_employer, only: [:show, :edit, :update]

  # GET /employers
  # GET /employers.json
  def index
    @employers = Employer.internal.sort_by { |employer| employer.name }
    @employers = @employers.paginate page: params[:page], per_page: 15
    @internal = true
  end

  # GET /employers/external
  # GET /employers/external.json
  def index_external
    @employers = Employer.external.sort_by { |employer| employer.name }
    @employers = @employers.paginate page: params[:page], per_page: 15
    @internal = false
    render 'index'
  end

  # GET /employers/1
  # GET /employers/1.json
  def show
    page = params[:page]
    @staff =  @employer.staff_members.where.not(id: @employer.deputy.id).paginate page: page
    @running_job_offers = @employer.job_offers.running.paginate page: page
    @open_job_offers = @employer.job_offers.open.paginate page: page
    @pending_job_offers = @employer.job_offers.pending.paginate page: page
  end

  # GET /employers/new
  def new
    @employer = Employer.new
  end

  # GET /employers/1/edit
  def edit
  end

  # POST /employers
  # POST /employers.json
  def create
    @employer = Employer.new employer_params
    @employer.deputy.employer = @employer if @employer.deputy

    if @employer.save
      respond_and_redirect_to @employer, I18n.t('users.messages.successfully_created.') , 'show', :created
    else
      @users = User.all
      flash[:error] = 'Invalid content.'
      render_errors_and_action @employer, 'new'
    end
  end

  # PATCH/PUT /employers/1
  # PATCH/PUT /employers/1.json
  def update
    if @employer.update employer_params
      respond_and_redirect_to @employer, I18n.t('users.messages.successfully_updated.')
    else
      render_errors_and_action @employer, 'edit'
    end
  end

  private

    def rescue_from_exception(exception)
      redirect_to employers_path, notice: exception.message
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_employer
      @employer = Employer.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employer_params
      params.require(:employer).permit(:name, :description, :avatar, :head, :deputy_id, :external)
    end
end
