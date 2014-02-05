module SessionsHelper

  def signed_in?
    return !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    redirect_to new_user_session_path, notice: I18n.t('layouts.messages.sign_in.') unless signed_in?
  end
end
