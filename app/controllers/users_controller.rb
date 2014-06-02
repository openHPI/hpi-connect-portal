class UsersController < ApplicationController

  skip_before_filter :signed_in_user, only: [:forgot_password]
  before_action :set_user, only: [:edit, :update]

  def edit
    authorize! :edit, @user
  end

  def update
    authorize! :update, @user
    if @user.update user_params
      respond_and_redirect_to([:edit, @user], I18n.t('users.messages.account_successfully_updated.'))
    else
      render_errors_and_action(@user, 'edit')
    end
  end

  def update_password
    @user = current_user
    if @user.authenticate params[:user][:old_password]
      if @user.update_attributes password_params
        flash[:success] = I18n.t('users.messages.password_changed')
      else
        flash[:error] = I18n.t('users.messages.passwords_not_matching')
      end
    else
      flash[:error] = I18n.t('users.messages.password_wrong')
    end
    redirect_to [:edit, @user]
  end

  def forgot_password
    @user = User.find_by_email params[:forgot_password][:email]
    if @user
      @user.set_random_password
      redirect_to root_path, notice: t('users.messages.password_resetted')
    else
      redirect_to root_path, notice: I18n.t('users.messages.unknown_email')
    end
  end

  private

    def set_user
      @user = User.find params[:id]
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def user_params
      params.require(:user).permit(:firstname, :lastname, :email)
    end
end
