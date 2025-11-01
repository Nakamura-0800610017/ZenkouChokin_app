require 'rails_helper'

RSpec.describe "パスワードリセット", type: :system do
  let(:user) { create(:user) }
  it "パスワードが変更できる" do
    visit new_password_reset_path
    fill_in "メールアドレス", with: user.email
    click_button "申請"
    expect(page).to have_content("パスワードリセットメールを送信しました")
    visit edit_password_reset_path(user.reload.reset_password_token)
    fill_in "パスワード", with: "123456"
    fill_in "パスワード確認", with: "123456"
    click_button "変更"
    expect(current_path).to eq login_path
    expect(page).to have_content("パスワードの更新に成功しました")
  end
end
