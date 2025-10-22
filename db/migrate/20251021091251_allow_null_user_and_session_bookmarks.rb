class AllowNullUserAndSessionBookmarks < ActiveRecord::Migration[7.2]
  def change
    remove_index :bookmarks, name: "index_bookmarks_on_user_id_and_post_id", if_exists: true

    change_column_null :bookmarks, :user_id, true
    add_column :bookmarks, :session_id, :string

    add_index :bookmarks, [ :user_id, :post_id ],
              unique: true,
              where: "user_id IS NOT NULL",
              name: "index_bookmarks_user_id_post"

    add_index :bookmarks, [ :session_id, :post_id ],
              unique: true,
              where: "session_id IS NOT NULL",
              name: "index_bookmarks_session_id_post"
  end
end
