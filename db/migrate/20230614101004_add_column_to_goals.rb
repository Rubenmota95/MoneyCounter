class AddColumnToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :favorite, :boolean, default: false
  end
end
