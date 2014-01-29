module UsersHelper

  def user_is_staff_of_employer?(job_offer)
    signed_in? and current_user.employer == job_offer.employer and current_user.staff?
  end

  def user_is_responsible_user?(job_offer)
    signed_in? && current_user == job_offer.responsible_user
  end

  def user_is_deputy_of_employer?(employer)
    signed_in? && current_user == @job_offer.employer.deputy
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
        language = language_class.where(:user_id => user_id, language_id_attribute.to_sym => id).first_or_create
        language.update_attributes(:skill => skill)
      end

      remove_for_language(params, user_id, language_class, language_id_attribute)
    else
      #If the User deselects all languages, they have to be destroyed
      language_class.destroy_all(:user_id => user_id)
    end
  end

  def remove_for_language(params, user_id, language_class, language_id_attribute)
    #Delete all programming languages which have been deselected (rating removed) from the form
    language_class.where(:user_id => user_id).each do |lang|
      if params[lang.attributes[language_id_attribute].to_s].nil?
        lang.destroy
      end
    end
  end

  def update_from_params_for_languages_and_newsletters(params, redirect_to)
    update_and_remove_for_newsletter(params[:employers_newsletter_information], params[:id], EmployersNewsletterInformation, "employer_id")
    update_and_remove_for_newsletter(params[:programming_languages_newsletter_information], params[:id], ProgrammingLanguagesNewsletterInformation, "programming_language_id")
    update_from_params_for_languages(params, redirect_to)
  end


  def update_from_params_for_languages(params, redirect_to)
    update_and_remove_for_language(params[:programming_languages], params[:id], ProgrammingLanguagesUser, "programming_language_id")
    update_and_remove_for_language(params[:languages], params[:id], LanguagesUser, "language_id")

    if @user.update(user_params)
      respond_and_redirect_to(redirect_to, 'User was successfully updated.')
    else
      render_errors_and_action(redirect_to, 'edit')
    end
  end

  def update_and_remove_for_newsletter(params, user_id, newsletter_class, attributes_id)
    if params
      params.each do |id, boolean|
        if boolean.to_i == 1
        newsletter_class.where(:user_id => user_id, attributes_id.to_sym => id).first_or_create
       end
      end
       remove_for_newsletter(params, user_id, newsletter_class, attributes_id)
    else
      newsletter_class.destroy_all(:user_id => user_id)
    end
  end

  def remove_for_newsletter(params, user_id, newsletter_class, attributes_id)
    newsletter_class.where(:user_id => user_id).each do |n|
      if params[n.attributes[attributes_id].to_s].to_i == 0
        n.delete
      end
    end
  end  

  def user_can_promote_students?
    return signed_in? && (current_user.admin? || user_is_deputy?)
  end

  def user_is_deputy?
    if(signed_in?)
      Employer.all.each do |employer|
        if employer.deputy_id == current_user.id
          current_user.employer_id = employer.id
          return true
        end
      end
    end
    return false
  end

end
