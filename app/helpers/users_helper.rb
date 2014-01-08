module UsersHelper

  def user_is_research_assistant_of_chair?(job_offer)
    signed_in? and current_user.chair == job_offer.chair and current_user.research_assistant?
  end

  def user_is_responsible_user?(job_offer)
    signed_in? && current_user == @job_offer.responsible_user
  end

  def user_is_deputy_of_chair?(chair)
    signed_in? && current_user == @job_offer.chair.deputy
  end
end
