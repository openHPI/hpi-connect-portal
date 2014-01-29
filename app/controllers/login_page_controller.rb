class LoginPageController < ApplicationController
include UsersHelper

skip_before_filter :signed_in_user, :only => :index

  # GET /
  def index
    if signed_in?
      redirect_to job_offers_path
    end
  end

end