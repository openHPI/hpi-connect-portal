class HomeController < ApplicationController
  skip_before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token

  def index
    @job_offers = JobOffer.last 5
    @employers = Employer.last 3
  end

  def imprint
  end

  def create
    user = User.find_by_email params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'index'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
