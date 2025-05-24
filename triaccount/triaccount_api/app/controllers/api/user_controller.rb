class Api::UsersController < ApiController
    skip_before_action :require_login, only: [:create] # Le indica que se aplique ese except
    before_action :set_user, only: [:show, :groups, :create_group]

    # /api/users
    def index
        @users = User.all
        render json: @users.as_json(except: [:password_digest])
    end

    # /api/users/id
    def show
        render json: @user.as_json(include: :groups)
    end

    # /api/users
    def create
        @user = User.new(user_params)
        if @user.save
            render json: status: :created
        else
            render json: { errors: @user.errors }, status: :unprocessable_entity
        end
    end

    def groups
        render json: @user.groups
    end

    # POST /api/users/id/groups
    def create_group
        @group = Group.new(group_params)
        if @group.save
            @group.users << @user;

            render json: @group.as_json(include: :users), status: :created
        else
            render json: {errors: @group.errors}, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :phone, :password)
    end

    def group_params
        params.require(:group).permit(:group_name, :total_expense, :balances, :refunds)
    end

    def set_user
        @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: {error: "Usuario no encontrado"}, status: :not_found
    end    
end

