# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admin_email    = ENV.fetch("ADMIN_EMAIL", nil)
admin_password = ENV.fetch("ADMIN_PASSWORD", nil)

# RUN_ADMIN_SEED が true の時だけ実行
if ENV["RUN_ADMIN_SEED"] == "true"
  if admin_email.present? && admin_password.present?
    admin = User.find_or_initialize_by(email: admin_email)
    admin.user_name = "管理者"
    admin.password = admin_password
    admin.password_confirmation = admin_password
    admin.role = "admin"   # enum role: { general: 0, admin: 1 } の場合
    admin.save!

    puts "✅ 管理者アカウントを作成または更新しました: #{admin.email}"
  else
    puts "⚠️ ADMIN_EMAIL または ADMIN_PASSWORD が設定されていません"
  end
else
  puts "ℹ️ RUN_ADMIN_SEED が true ではないため、管理者作成はスキップしました"
end
