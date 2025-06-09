class CreateUserPoints < ActiveRecord::Migration[7.2]
  def change
    create_table :user_points do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_points, default: 0, null: false
      t.integer :user_rank, default: 0, null: false

      t.timestamps
    end
    add_index :user_points, :total_points
  end
end
