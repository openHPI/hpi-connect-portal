class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :set_constants

  before_filter :signed_in_user

  # before_filter do
  #   resource = controller_name.singularize.to_sym
  #   method = "#{resource}_params"
  #   params[resource] &&= send(method) if respond_to?(method, true)
  # end

  rescue_from CanCan::AccessDenied do |exception|
    rescue_from_exception exception
  end

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

  def render_errors_and_action(object, action = nil)
    respond_to do |format|
        if action.nil?
          format.html { redirect_to object }
        else
          format.html { render action: action }
        end
        format.json { render json: object.errors, status: :unprocessable_entity }
    end
  end

  def respond_and_redirect_to(url, notice = nil, action = nil, status = nil)
    respond_to do |format|
      format.html { redirect_to url, flash: { success: notice } }
      if action && status
        format.json { render action: action, status: status, location: object }
      end
    end
  end

  protected

    def set_constants
      @flagnames = {
        en: "famfamfam-flag-gb",
        de: "famfamfam-flag-de"
      }
    end

    def rescue_from_exception(exception)
      redirect_to root_path
    end
end
