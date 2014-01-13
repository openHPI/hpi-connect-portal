module UsersHelper

  def user_is_staff_of_chair?(job_offer)
    signed_in? and current_user.chair == job_offer.chair and current_user.staff?
  end

  def user_is_responsible_user?(job_offer)
    signed_in? && current_user == @job_offer.responsible_user
  end

  def user_is_deputy_of_chair?(chair)
    signed_in? && current_user == @job_offer.chair.deputy
  end

  def user_is_staff?
    signed_in? && current_user.staff?
  end

  def user_is_admin?
  	signed_in? && current_user.admin?
  end

  def update_and_remove_for_language(params, user_id, language_class, language_id_attribute)
    if params
      params.each do |id, skill|
        l = language_class.where(:user_id => user_id, language_id_attribute.to_sym => id).first_or_create
        l.update_attributes(:skill => skill)
      end

      remove_for_language(params, user_id, language_class, language_id_attribute)
    else
      #If the User deselects all languages, they have to be destroyed
      language_class.destroy_all(:user_id => user_id)
    end
  end

  def remove_for_language(params, user_id, language_class, language_id_attribute)
    #Delete all programming languages which have been deselected (rating removed) from the form
    language_class.where(:user_id => user_id).each do |l|
      if params[l.attributes[language_id_attribute].to_s].nil?
        l.destroy
      end
    end
  end
end
