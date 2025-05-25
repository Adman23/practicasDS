class Api::SessionsController < ApiController
    skip_before_action :require_login, only: [:create] # Le indica que se aplique ese except

    #login
    def create()
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
            token = SecureRandom.hex(32)
            user.update(auth_token: token)
            render json: {auth_token: token, user: user.as_json(except: [:password_digest])}
        else
            render json: { error: "Email o contraseña inválidos"}, status: :unauthorized
        end
    end

    #logout
    def destroy()
        user = User.find_by(auth_token: request.headers["Authorization"])
        user&.update(auth_token: nil) if user
        head :no_content
    end

end