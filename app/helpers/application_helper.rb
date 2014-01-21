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
    if(signed_in?)
      Chair.all.each do |chair|
        if chair.deputy_id == current_user.id
          current_user.chair_id = chair.id
          return true
        end
      end
    end
    return false
  end
end
