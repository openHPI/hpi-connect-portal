class ApplicationController < ActionController::Base
  include SessionsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
  { locale: I18n.locale }
  end
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    edit_user_path(resource)
  end

  def render_errors_and_action(object, action)
    respond_to do |format|
        format.html { render action: action }
        format.json { render json: object.errors, status: :unprocessable_entity }
    end
  end 

  def respond_and_redirect_to(url, notice, action=nil, status=nil)
    respond_to do |format|
      format.html { redirect_to url, notice: notice }
      if action && status
        format.json { render action: action, status: status, location: object }
      end
    end
  end

  def set_role(role_name, chair_name, user_id)
    if chair_name
      chair = Chair.find_by_name(chair_name)
    else
      chair = current_user.chair
    end

    case role_name
      when "Deputy"
        set_role_to_deputy(user_id, chair)
      when Role.find_by_level(3).name
        set_role_to_admin(user_id)
      when Role.find_by_level(2).name
        set_role_to_staff(user_id, chair)
      when Role.find_by_level(1).name
        set_role_to_student(user_id)
    end
  end

    def set_role_to_deputy(user_id, chair)
    chair.update(:deputy_id => user_id)
    User.find(user_id).update(:chair => chair, :role => Role.find_by_level(2))
  end

  def set_role_to_admin(user_id)
    student = User.find(user_id)
    student.update(:role => Role.find_by_level(3))
  end

  def set_role_to_staff(user_id, chair)
    student = User.find(user_id)
    student.update(:role => Role.find_by_level(2), :chair => chair)
  end

  def set_role_to_student(user_id)
    user = User.find(user_id)
    user.update(:role => Role.find_by_level(1), :chair => nil)
  end

  def set_role_from_staff_to_student(user_id, deputy_id)
    user = User.find(user_id)
    if deputy_id
      user.chair.update(:deputy_id => deputy_id)
    end   
    user.update(:role_id => Role.find_by_level(1).id, :chair => nil)

  end

end
