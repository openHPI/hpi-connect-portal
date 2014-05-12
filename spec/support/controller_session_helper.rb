require 'spec_helper'

module ControllerSessionHelper

  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    User.find_by_id session[:user_id]
  end
end
