class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :title
      t.float :cost
      t.datetime :date
      t.json :participants
      t.references :buyer, null: false, foreign_key: { to_table: :user}
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
