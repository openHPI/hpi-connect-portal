class SessionsController < ApplicationController
  skip_before_filter :signed_in_user

  def create
    user = User.find_by_email params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if user.staff?
        redirect_back_or home_employers_path
      else
        if user.alumni? && Alumni.email_invalid?(user.email)
          respond_and_redirect_to edit_user_path(user), {error: I18n.t('alumni.choose_another_email')}
        else
          redirect_back_or root_path
        end
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
