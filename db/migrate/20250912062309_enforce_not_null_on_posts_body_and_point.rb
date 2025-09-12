class EnforceNotNullOnPostsBodyAndPoint < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :body,  false
    change_column_null :posts, :point, false
  end
end
