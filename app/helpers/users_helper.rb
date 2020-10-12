# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)      default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  lastname           :string(255)
#  firstname          :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  cv_file_name       :string(255)
#  cv_content_type    :string(255)
#  cv_file_size       :integer
#  cv_updated_at      :datetime
#  status             :integer
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#  admin              :boolean          default(FALSE), not null
#  alumni_email       :string(255)      default(""), not null
#

module UsersHelper

  def user_is_staff_of_employer?(job_offer)
    signed_in? && current_user.staff? && current_user.manifestation.employer == job_offer.employer
  end

  def update_and_remove_for_language(params, student_id, language_class, language_id_attribute)
    if params
      params.each do |id, skill|
        language = language_class.where(student_id: student_id, language_id_attribute.to_sym => id).first_or_create
        language.update(skill: skill)
      end

      remove_for_language(params, student_id, language_class, language_id_attribute)
    else
      language_class.where(student_id: student_id).destroy_all
    end
  end

  def remove_for_language(params, student_id, language_class, language_id_attribute)
    language_class.where(student_id: student_id).each do |lang|
      if params[lang.attributes[language_id_attribute].to_s].nil?
        lang.destroy
      end
    end
  end

  def update_from_params_for_languages(params, redirect_to)
    #update_and_remove_for_language(params[:programming_language_skills], params[:id], ProgrammingLanguagesUser, "programming_language_id")
    update_and_remove_for_language(params[:language_skills], params[:id], LanguagesUser, "language_id")
  end

end
