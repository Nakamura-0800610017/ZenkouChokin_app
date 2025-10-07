require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system, js: true do
  context '利用規約' do
    it 'チェックボックスをクリックすると登録ボタンが利用可能になる' do
      visit '/users/new'
      expect(page).to have_button('新規登録', disabled: true)
      expect(page).to have_css("[data-terms-target='submit'].btn-secondary")
      find('#user_terms_of_service').check
      expect(page).to have_no_css("input[type='submit'][disabled]")
      expect(page).to have_css("[data-terms-target='submit'].btn-primary")
      expect(page).to have_no_css("[data-terms-target='submit'].btn-secondary")
    end
  end
  context '入力情報正常系' do
    it 'ユーザーが新規作成できること' do
      visit '/users/new'
      expect {
        fill_in 'ユーザーネーム', with: 'スペックテスト'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: '12345678'
        fill_in 'パスワード確認', with: '12345678'
        find('#user_terms_of_service').click
        click_button '新規登録'
        Capybara.assert_current_path("/", ignore_query: true)
      }.to change { User.count }.by(1)
      expect(page).to have_content('ユーザーを作成しました')
    end
  end

  context '入力情報異常系' do
    it 'ユーザーが新規作成できない' do
      visit '/users/new'
      expect {
        fill_in 'メールアドレス', with: 'example@example.com'
        find('#user_terms_of_service').click
        click_button '新規登録'
      }.to change { User.count }.by(0)
      expect(page).to have_content('ユーザーの作成に失敗しました')
      expect(page).to have_content('ユーザーネームを入力してください')
      expect(page).to have_content('パスワードは6文字以上で入力してください')
    end
  end
end
