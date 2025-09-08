class RelaxEmailForOauthUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :email, true
    remove_index :users, name: "index_users_on_email"
    add_index :users, :email, name: "index_users_on_email", unique: true, where: "email IS NOT NULL"
  end
end
