class AddModeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :mode, :integer, null: false, default: 0
    add_index :users, :mode
  end
end
