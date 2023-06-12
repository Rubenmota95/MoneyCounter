class CreateIncomes < ActiveRecord::Migration[7.0]
  def change
    create_table :incomes do |t|
      t.float :amount
      t.string :category
      t.string :name
      t.boolean :recurring
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
