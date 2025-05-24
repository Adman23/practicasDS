class Api::ExpensesController < ApplicationController
    # Para todas las acciones se settea el group
    before_action :set_group
    # Para esas acciones se busca el expense
    before_action :set_expense, only: [:show, :update, :destroy]

    # GET /groups/id/expenses
    def index
        @expenses = @group.expenses
        render json: @expenses
    end

    # GET /groups/id/expenses/id_ex
    def show
        render json: @expense.as_json(methods: [:image_url])
    end

    # POST /groups/id/expenses
    def create
        @expense = @group.expenses.new(expense_params)
        if @expense.save
            if params[:image]
                @expense.image.attach(params[:image])
            end
            render json: @expense, status: :created
        else
            render json: { errors: @expense.errors }, status: :unprocessable_entity
        end
    end

    # PUT /groups/id/expenses/id_ex
    def update
        if @expense.update(expense_params)
            if (params[:image] && !@expense.image.attached?)
                @expense.image.attach(params[:image])
            elsif (params[:image])
                @expense.image.detach
                @expense.image.attach(params[:image])
            end
            render json: @expense
        else
            render json: { errors: @expense.errors }, status: :unprocessable_entity
        end
    end

    # DELETE /groups/id/expenses/id_ex
    def destroy
        if @expense.destroy
            head :ok
        else
            render json: { error: "No se pudo eliminar el gasto" }, status: :unprocessable_entity
        end
    end

    private

    def set_group
        @group = Group.find(params[:group_id])
    rescue ActiveRecord::RecordNotFound
        render json: {error: "Grupo no encontrado"}, status: :not_found
    end

    def set_expense
        @expense = @group.expenses.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: {error: "Expense no encontrado"}, status: :not_found
    end

    def expense_params
        params.require(:expense).permit(
        :title,
        :cost,
        :date,
        :buyer_id,
        participants: []
        )
    end

    def image_url
        return unless @expense.foto.attached?
        Rails.application.routes.url_helpers.url_for(@expense.image)
    end
end
