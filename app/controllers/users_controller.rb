# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)      default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  lastname           :string(255)
#  firstname          :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  cv_file_name       :string(255)
#  cv_content_type    :string(255)
#  cv_file_size       :integer
#  cv_updated_at      :datetime
#  status             :integer
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#  admin              :boolean          default(FALSE), not null
#  alumni_email       :string(255)      default(""), not null
#

class UsersController < ApplicationController

  skip_before_action :signed_in_user, only: [:forgot_password]
  before_action :set_user, only: [:edit, :update]

  def edit
    authorize! :edit, @user
  end

  def update
    authorize! :update, @user
    if @user.update user_params.to_h
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
    email = params[:forgot_password][:email]
    if email.blank?
      redirect_to root_path, notice: I18n.t('users.messages.unknown_email')
    else
      @user = User.where('lower(email) = ?', email.downcase).first
      if @user
        @user.set_random_password
        redirect_to root_path, notice: t('users.messages.password_resetted')
      else
        redirect_to root_path, notice: I18n.t('users.messages.unknown_email')
      end
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
