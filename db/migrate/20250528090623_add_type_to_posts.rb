class AddTypeToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :post_type, :integer, default: 0, null: false
  end
end
