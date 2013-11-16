class SessionsController < Devise::SessionsController
    skip_before_filter :verify_authenticity_token
    before_filter :update_sanitized_params

    def update_sanitized_params
        devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:identity_url)}
    end
end
