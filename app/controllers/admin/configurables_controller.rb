class Admin::ConfigurablesController < ApplicationController
  # include the engine controller actions
  include ConfigurableEngine::ConfigurablesControllerMethods

  load_and_authorize_resource

  before_action :validation

  layout 'configurable'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  private
    def validation
      if (!params[:mailToAdministration].nil? and !VALID_EMAIL_REGEX.match(params[:mailToAdministration])) or (!params[:administration_cc].nil? and !VALID_EMAIL_REGEX.match(params[:administration_cc]))
        redirect_to admin_configurable_path, notice: t("errors.configuration.invalid_email")
      end
    end
end
