class EmployersController < ApplicationController
  include ApplicationHelper
  
  authorize_resource only: [:new, :edit, :create, :update]
  before_action :set_employer, only: [:show, :edit, :update, :find_jobs]

  rescue_from CanCan::AccessDenied do |exception| 
    redirect_to employers_path, :notice => exception.message
  end

  # GET /employers
  # GET /employers.json
  def index
    @employers = Employer.all.sort_by{|x| x.name}
    @employers = @employers.paginate(:page => params[:page], :per_page => 15 )
  end

  # GET /employers/1
  # GET /employers/1.json
  def show
    @staff = @employer.staff.paginate(:page => params[:page])
    @running_job_offers = @employer.job_offers.running.paginate(:page => params[:page])
    @open_job_offers = @employer.job_offers.open.paginate(:page => params[:page])
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

    @employer = Employer.new(employer_params)

    if @employer.save
      respond_and_redirect_to(@employer, 'Employer was successfully created.', 'show', :created)
    else
			@users = User.all
      flash[:error] = 'Invalid content.'
      render_errors_and_action(@employer, 'new')
    end
  end

  # PATCH/PUT /employers/1
  # PATCH/PUT /employers/1.json
  def update
    if @employer.update(employer_params)
      respond_and_redirect_to(@employer, 'Employer was successfully updated.')
    else
      render_errors_and_action(@employer, 'edit')
    end
  end

  def find_jobs
    show
    render "show"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employer
      @employer = Employer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employer_params
      params.require(:employer).permit(:name, :description, :avatar, :head, :deputy_id)
    end
end
