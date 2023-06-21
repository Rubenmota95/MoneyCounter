class AddGroupStatusToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :group_status, :boolean, default: false
  end
end
