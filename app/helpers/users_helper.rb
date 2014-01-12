module UsersHelper

  def user_is_research_assistant_of_chair?(job_offer)
    signed_in? and current_user.chair == job_offer.chair and current_user.research_assistant?
  end

  def user_can_promote_students?
    return signed_in? && (current_user.admin? || user_is_deputy?)
  end

  def user_is_deputy?
    Chair.all.each do |chair|
      if chair.deputy_id == current_user.id
        current_user.chair_id = chair.id
        return true
      end
    end
    return false
  end
end