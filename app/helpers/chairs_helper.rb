module ChairsHelper
  def user_can_demote_staff?
    return signed_in? && (current_user.admin? || user_is_deputy?)
  end
end
