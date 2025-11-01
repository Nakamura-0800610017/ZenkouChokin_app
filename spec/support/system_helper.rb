module SystemHelper
  def login_as(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    Capybara.assert_current_path("/", ignore_query: true)
  end
  def login_as_admin(user)
    visit admin_login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    Capybara.assert_current_path("/admin", ignore_query: true)
  end
end

RSpec.configure do |config|
  config.include SystemHelper
end
