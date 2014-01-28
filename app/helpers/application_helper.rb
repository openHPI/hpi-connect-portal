module ApplicationHelper
  def resource_name
      :user
  end

  def resource
      @resource ||= User.new
  end

  def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
  end

  def user_is_deputy?
    given_user_is_deputy?(current_user)
  end

  def given_user_is_deputy?(user)
    if(signed_in?)
      Chair.all.each do |chair|
        if chair.deputy_id == user.id
          user.chair_id = chair.id
          return true
        end
      end
    end
    return false
  end
end
