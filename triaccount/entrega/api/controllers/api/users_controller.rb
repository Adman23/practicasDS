class Api::UsersController < ApiController
    skip_before_action :require_login, only: [:create] # Le indica que se aplique ese except
    before_action :set_user, only: [:show, :groups, :create_group, :update, :destroy_group, :destroy]

    # /api/users
    def index
        users = User.all
        render json: users.as_json(except: [:password_digest])
    end

    # /api/users/id
    def show
        render json: @user.as_json(include: :groups)
    end

    # /api/retrieve_user
    def retrieve_user
        user = User.find_by(auth_token: request.headers["Authorization"])
        render json: user.as_json(include: :groups), status: :ok
    end

    # /api/users
    def create
        user = User.new(user_params)
        if user.save
            render json: user, status: :created
        else
            render json: { errors: "NO HA PODIDO REGISTRAR" }, status: :unprocessable_entity
        end
    end

    # delete api/users/id
    def destroy
        if @user.destroy
            head :no_content
        else
            render json: { errors: @user.errors }, status: :unprocessable_entity
        end
    end
        

    def update
        if @user.update(username: params[:username])
            head :no_content
        else
            render json: {errors: "No se ha podido actualizar el username"}
        end
    end

    def groups
        render json: @user.groups.as_json(include: {
            users: { except: [:password_digest, :auth_token]},
            expenses: {
                include: {buyer: {except: [:password_digest, :auth_token]}},
            }
        }), status: :ok
    end


    # POST /api/users/id/groups
    def create_group
        group = Group.new(group_params)
        if group.save
            group.users << @user;
            render json: group.as_json(include: {
            users: { except: [:password_digest, :auth_token]},
            expenses: {
                include: {buyer: {except: [:password_digest, :auth_token]}},
                }
            }), status: :created
        else
            render json: {errors: group.errors}, status: :unprocessable_entity
        end
    end

    # DELETE /api/users/id/groups/group_id
    def destroy_group
        group = @user.groups.find(params[:group_id])
        if group.destroy
            head :no_content
        else
            render json: { errors: group.errors }, status: :unprocessable_entity
        end
    end


    private

    def user_params
        params.require(:user).permit(:username, :email, :phone, :password)
    end

    def group_params
        params.require(:group).permit(:group_name, :total_expense, balances: {}, refunds: {})
    end

    def set_user
        @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: {error: "Usuario no encontrado"}, status: :not_found
    end    
end

