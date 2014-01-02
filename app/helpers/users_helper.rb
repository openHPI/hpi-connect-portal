module UsersHelper

  def user_is_research_assistant_of_chair?(job_offer)
    signed_in? and current_user.chair == job_offer.chair and current_user.research_assistant?
  end
end
