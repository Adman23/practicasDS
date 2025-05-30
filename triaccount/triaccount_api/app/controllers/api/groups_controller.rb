class Api::GroupsController < ApiController
    before_action :set_group, only: [:show, :update, :users, :add_user, :remove_user]

    # un GET /api/groups   -> Devolver todos los grupos (no se usará tanto)
    def index
        groups = Group.all
        render json: groups
    end

    # un GET /api/groups/id -> Devolver los usuarios de un grupo
    def show
        render json: @group.as_json(include: [:users.as_json(except: [:password_digest, :auth_token]), :expenses.as_json])
    end

    # un POST /api/groups/id -> Modificar los parámetros que se hayan cambiado (quizás se podría hacer aqui el cambio)
    def update
        if @group.update(group_params)
            head :no_content
        else
            render json: { errors: @group.errors }, status: :unprocessable_entity
        end
    end

    # DELETE /api/groups/id
    def delete
        if @group.destroy
            head :ok
        else
            render json: { error: "No se pudo eliminar grupo" }, status: :unprocessable_entity
        end
    end

    # GET de los users /api/groups/id/users
    def users
        render json: @group.users
    end

    # POST /api/groups/id/users
    def add_user
        user = User.find_by(email: params[:email])
        if user.nil?
            render json: {error: "El usuario no existe"}, status: :unprocessable_entity
        elsif @group.users.include?(user)
            render json: {error: "El usuario ya está en el grupo"}, status: :unprocessable_entity
        else
            username = user.username
            if @group.balances&.key?(username)
                username = "#{user.username}_#{user.email}"
            end

            @group.balances[username] = 0
            @group.refunds[username] = {}
            @group.save!
            @group.users << user

            render json: {  user: user.as_json(except: [:password_digest]),
                            usernameKey: username}, status: :ok
        end
    end

    # DELETE /api/groups/id/users/user_id

    def remove_user
        user = User.find(params[:user_id])
        if user && @group.users.include?(user)
            if @group.users.delete(user)
                head :no_content
            else
                render json: { error: "No se pudo eliminar usuario" }, status: :unprocessable_entity
            end
        else
            render json: { error: "Usuario no está en el grupo o no existe"}, status: :not_found    
        end
    end
    
    private

    def group_params
        params.require(:group).permit(:group_name, :total_expense, balances: {}, refunds: {})
    end

    def set_group 
        @group = Group.find(params[:id])
    end
end
