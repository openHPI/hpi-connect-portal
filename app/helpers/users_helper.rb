module UsersHelper
  def user_is_research_assistant_of_chair?(job_offer)
    signed_in? and current_user.chair_id == job_offer.chair_id and current_user.research_assistant?
  end
end
