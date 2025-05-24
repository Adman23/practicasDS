class Api::GroupsController < ApiController
    before_action :set_group, only: [:show, :update, :destroy, :users, :add_user, :remove_user]

    # un GET /api/groups   -> Devolver todos los grupos (no se usará tanto)
    def index
        @groups = Group.all
        render json: @groups
    end

    # un GET /api/groups/id -> Devolver los usuarios de un grupo
    def show
        render json: group.as_json(include: [:users, :expenses])
    end

    # un POST /api/groups/id -> Modificar los parámetros que se hayan cambiado (quizás se podría hacer aqui el cambio)
    def update
        if @group.update(group_params)
            render json: @group
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

    # POST /api/groups/id/users/id_u
    def add_user
        @user = User.find(params[:user_id])
        if @user.nil?
            render json: {error: "El usuario no existe"}, status: :unprocessable_entity
        elsif @group.users.include?(@user)
            render json: {error: "El usuario ya está en el grupo"}, status: :unprocessable_entity
        else
            @group.users << @user
            render json: {message: "Usuario añadido", user: user.as_json}, status: :created
        end
    end

    # DELETE /api/groups/id/users/id_u
    def remove_user
        @user = User.find(params[:user_id])
        if @user && @group.users.include?(@user)
            if @group.users.delete(@user)
                head :ok
            else
                render json: { error: "No se pudo eliminar usuario" }, status: :unprocessable_entity
            end
        else
            render json: {error: "Usuario no está en el grupo o no existe"}, status: :not_found    
        end
    end
    
    private

    def group_params
        params.require(:group).permit(:group_name, :balances, :refunds, :total_expense)
    end

    def set_group 
        @group = Group.find(params[:id])
    end
end
