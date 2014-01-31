class UserStatusesController < ApplicationController
  before_action :set_user_status, only: [:show, :edit, :update, :destroy]

  # GET /user_statuses
  # GET /user_statuses.json
  def index
    @user_statuses = UserStatus.all
  end

  # GET /user_statuses/1
  # GET /user_statuses/1.json
  def show
  end

  # GET /user_statuses/new
  def new
    @user_status = UserStatus.new
  end

  # GET /user_statuses/1/edit
  def edit
  end

  # POST /user_statuses
  # POST /user_statuses.json
  def create
    @user_status = UserStatus.new user_status_params

    if @user_status.save
      respond_and_redirect_to @user_status, 'Student status was successfully created.', 'show', :created
    else
      render_errors_and_action @user_status, 'new'
    end
  end

  # PATCH/PUT /user_statuses/1
  # PATCH/PUT /user_statuses/1.json
  def update
    if @user_status.update user_status_params
      respond_and_redirect_to @user_status, 'Student status was successfully updated.'
    else
      render_errors_and_action @user_status, 'edit'
    end
  end

  # DELETE /user_statuses/1
  # DELETE /user_statuses/1.json
  def destroy
    @user_status.destroy
    respond_and_redirect_to user_statuses_url, 'User status has been successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_status
      @user_status = UserStatus.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_status_params
      params.require(:user_status).permit(:name)
    end
end
