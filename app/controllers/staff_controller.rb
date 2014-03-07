class StaffController < ApplicationController
  include UsersHelper

  authorize_resource class: "User"

  before_action :set_staff, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :index, Staff.all
    @staff_members = apply_scopes(Staff.all).sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: params[:page], per_page: 5)
  end

  def show
  end

  def edit
    authorize! :edit, @staff
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
  end

  def update
    update_from_params_for_languages params, staff_path(@staff)
  end

  def destroy
    authorize! :destroy, @staff
    @staff.destroy
    respond_and_redirect_to staff_index_path, I18n.t('users.messages.successfully_deleted.')
  end

  private

    def rescue_from_exception(exception)
      if [:index].include? exception.action
        respond_and_redirect_to root_path, exception.message
      elsif [:edit].include? exception.action
        respond_and_redirect_to exception.subject, exception.message
      else
        respond_and_redirect_to staff_index_path, exception.message
      end
    end

    def set_staff
      @staff = Staff.find params[:id]
    end
end