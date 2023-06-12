class CreateGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :goals do |t|
      t.string :name
      t.float :amount
      t.string :caregory
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
