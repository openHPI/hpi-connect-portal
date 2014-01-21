class ChairsController < ApplicationController
  authorize_resource only: [:new, :edit, :create, :update]

  include ApplicationHelper
  before_action :set_chair, only: [:show, :edit, :update, :find_jobs, :update_staff]

  rescue_from CanCan::AccessDenied do |exception| 
    redirect_to chairs_path, :notice => exception.message
  end

  # GET /chairs
  # GET /chairs.json
  def index
    @chairs = Chair.all.sort_by{|x| x.name}
    @chairs = @chairs.paginate(:page => params[:page], :per_page => 15 )
  end

  # GET /chairs/1
  # GET /chairs/1.json
  def show
    @staff = @chair.staff.paginate(:page => params[:page])
    @running_job_offers = @chair.job_offers.running.paginate(:page => params[:page])
    @open_job_offers = @chair.job_offers.open.paginate(:page => params[:page])
  end

  # GET /chairs/new
  def new
    @chair = Chair.new
  end

  # GET /chairs/1/edit
  def edit
  end

  # POST /chairs
  # POST /chairs.json
  def create

    @chair = Chair.new(chair_params)

    if @chair.save
      respond_and_redirect_to(@chair, 'Chair was successfully created.', 'show', :created)
    else
			@users = User.all
      flash[:error] = 'Invalid content.'
      render_errors_and_action(@chair, 'new')
    end
  end

  # PATCH/PUT /chairs/1
  # PATCH/PUT /chairs/1.json
  def update
    if @chair.update(chair_params)
      respond_and_redirect_to(@chair, 'Chair was successfully updated.')
    else
      render_errors_and_action(@chair, 'edit')
    end
  end

  def update_staff
    set_role_from_staff_to_student(params[:student_id], params[:new_deputy_id])
    redirect_to(chair_path(@chair))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair
      @chair = Chair.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chair_params
      params.require(:chair).permit(:name, :description, :avatar, :head_of_chair, :deputy_id)
    end
end
