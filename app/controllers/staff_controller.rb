class StaffController < ApplicationController
  include UsersHelper

  authorize_resource

  before_action :set_staff, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :index, Staff.all
    @staff_members = Staff.all.sort_by { |user| [user.lastname, user.firstname] }.paginate(page: params[:page], per_page: 5)
  end

  def show
  end

  def new
    @staff = Staff.new
    @staff.build_user
  end

  def create
    @staff = Staff.new staff_params
    if @staff.save
      sign_in @staff.user
      flash[:success] = "Welcome to HPI Career!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    authorize! :destroy, @staff
    @staff.destroy
    respond_and_redirect_to staff_index_path, I18n.t('users.messages.successfully_deleted.')
  end

  private

    def set_staff
      @staff = Staff.find params[:id]
    end

    def staff_params
      params.require(:staff).permit(:employer, user_attributes: [:firstname, :lastname, :email, :password, :password_confirmation])
    end

    def rescue_from_exception(exception)
      if [:index].include? exception.action
        respond_and_redirect_to root_path, exception.message
      elsif [:edit].include? exception.action
        respond_and_redirect_to exception.subject, exception.message
      else
        respond_and_redirect_to staff_index_path, exception.message
      end
    end
end