class LoginPageController < ApplicationController
include UsersHelper

  # GET /
  def index
    if signed_in?
      redirect_to job_offers_path
    end
  end

end