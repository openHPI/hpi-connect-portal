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

  def mark_if_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveRecord::Validations::PresenceValidator  
  end 

  def sanitize_html(html)
    Sanitize.clean(html, Sanitize::Config::BASIC).html_safe
  end
end
