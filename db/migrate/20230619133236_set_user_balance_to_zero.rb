class SetUserBalanceToZero < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :balance, :float, null: false, default: 0
  end
end
