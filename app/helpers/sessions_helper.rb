module SessionsHelper

    def signed_in?
        return !current_user.nil?
    end

    def current_user?(user)
        user == current_user
    end

    def signed_in_user
        store_location and redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def redirect_back_or(default)
        redirect_to(session[:return_to] || default)
        session.delete :return_to
    end

    def store_location
        session[:return_to] = request.url
    end
end
