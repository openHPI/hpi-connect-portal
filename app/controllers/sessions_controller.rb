class SessionsController < ApplicationController
  skip_before_filter :signed_in_user

  def create
    user = User.find_by_email params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
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
