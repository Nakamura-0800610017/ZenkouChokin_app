class ChangeTotalPointsToDecimalInUserPoints < ActiveRecord::Migration[7.2]
  def change
    change_column :user_points, :total_points, :decimal, precision: 10, scale: 1, default: 0, null: false
  end
end
