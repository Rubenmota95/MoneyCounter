class ChangeCollumnNameAndType < ActiveRecord::Migration[7.0]
  def change
    change_table :expenses do |t|
      t.rename :recurring, :frequency
      t.change :frequency, :string
    end
    change_table :incomes do |t|
      t.rename :recurring, :frequency
      t.change :frequency, :string
    end
    change_table :goals do |t|
      t.rename :caregory, :category
    end
  end
end
