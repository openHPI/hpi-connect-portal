class ImprintController < ApplicationController
  skip_before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token

  def index
  end
end
