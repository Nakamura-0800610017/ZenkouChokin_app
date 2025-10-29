require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system, js: true do
  let(:user1) { create(:user) }
  let(:post1) { create(:post, :zenkou, user: user1, created_at: DateTime.new(2025, 10, 1)) }
  describe "ユーザー作成" do
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
  describe "マイページ表示" do
    before do
      user1
      post1
      login_as(user1)
    end
    it "マイページに正しく表示がされている" do
      visit user_path(user1)
      expect(page).to have_content(user1.user_name)
      expect(page).to have_content(user1.user_point.total_points.round)
      expect(page).to have_content(post1.body)
    end
  end
  describe "ユーザー更新" do
    before do
      user1
      login_as(user1)
      visit edit_user_path(user1)
    end
    it "更新できる" do
      fill_in "ユーザーネーム", with: "新ユーザーネーム"
      click_on "更新"
      expect(page).to have_content("ユーザーを更新しました")
      expect(current_path).to eq user_path(user1)
    end
    it "更新できない" do
      fill_in "ユーザーネーム", with: " "
      click_on "更新"
      expect(page).to have_content("ユーザーの更新に失敗しました")
      expect(page).to have_content("ユーザーネームを入力してください")
    end
  end
  describe "ユーザー削除", js: true do
    it "ユーザーを削除できる" do
      user1
      login_as(user1)
      visit edit_user_path(user1)
      accept_confirm { click_on "アカウント削除" }
      expect(page).to have_content("ユーザーを削除しました")
      expect(current_path).to eq root_path
    end
  end
end
