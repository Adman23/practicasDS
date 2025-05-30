class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :group_name
      t.json :balances
      t.json :refunds
      t.float :total_expense

      t.timestamps
    end
  end
end
