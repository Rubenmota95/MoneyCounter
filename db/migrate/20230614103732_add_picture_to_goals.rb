class AddPictureToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :picture, :string
  end
end
