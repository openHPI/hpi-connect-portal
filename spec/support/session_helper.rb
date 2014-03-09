require 'spec_helper'

module SessionHelper

  def sign_in(user)
    request.session[:user_id] = user.id
  end

  def current_user
    User.find request.session[:user_id]
  end
end
