class AddIsRefundToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :is_refund, :boolean, default: false, null: false
  end
end
