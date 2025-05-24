class ApiController < ApplicationController
    private
    before_action :require_login, except: [:create]

    private

    def require_login
        unless logged_in?
            render json: {error:"Hace falta inciar sesión"}, status: :unauthorized
        end
    end

    def logged_in?
        !!current_user
    end

    def current_user
        @current_user ||= User.find_by(auth_token: request.headers["Authorization"])
    end
end