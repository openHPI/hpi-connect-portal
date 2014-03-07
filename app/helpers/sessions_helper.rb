module SessionsHelper

  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end

  def signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end

  def current_user?(user)
    user == current_user
  end

  def user_type
    current_user.manifestation_type
  end

  def signed_in_user
    store_location and redirect_to root_url, notice: I18n.t('layouts.messages.sign_in.') unless signed_in?
  end

  def sign_out
    self.current_user = nil
    session[:user_id] = nil
  end

  def redirect_back_or(default)
    url = session[:return_to] if session[:requesting_user_type].nil? || user_type == session[:requesting_user_type]
    url ||= default
    redirect_to url
    session.delete :return_to
    session.delete :requesting_user_type
  end

  def store_location(specialuser_type=nil)
    session[:requesting_user_type] = specialuser_type
    session[:return_to] = request.url
  end
end
