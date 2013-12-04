class StudentStatusesController < ApplicationController
  before_action :set_student_status, only: [:show, :edit, :update, :destroy]

  # GET /student_statuses
  # GET /student_statuses.json
  def index
    @student_statuses = StudentStatus.all
  end

  # GET /student_statuses/1
  # GET /student_statuses/1.json
  def show
  end

  # GET /student_statuses/new
  def new
    @student_status = StudentStatus.new
  end

  # GET /student_statuses/1/edit
  def edit
  end

  # POST /student_statuses
  # POST /student_statuses.json
  def create
    @student_status = StudentStatus.new(student_status_params)

    respond_to do |format|
      if @student_status.save
        format.html { redirect_to @student_status, notice: 'Student status was successfully created.' }
        format.json { render action: 'show', status: :created, location: @student_status }
      else
        format.html { render action: 'new' }
        format.json { render json: @student_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_statuses/1
  # PATCH/PUT /student_statuses/1.json
  def update
    respond_to do |format|
      if @student_status.update(student_status_params)
        format.html { redirect_to @student_status, notice: 'Student status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @student_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_statuses/1
  # DELETE /student_statuses/1.json
  def destroy
    @student_status.destroy
    respond_to do |format|
      format.html { redirect_to student_statuses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_status
      @student_status = StudentStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_status_params
      params.require(:student_status).permit(:name)
    end
end
