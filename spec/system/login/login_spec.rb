require 'rails_helper'

RSpec.describe "ログイン・ログアウト", type: :system do
  let(:general_user) { create(:user, :general) }
  let(:admin_user) { create(:user, :admin) }

  describe "通常ユーザー" do
    describe "ログイン" do
      it "ログイン失敗時にフラッシュメッセージが表示される" do
        visit login_path
        fill_in "メールアドレス", with: general_user.email
        click_button "ログイン"
        expect(page).to have_content("ログインに失敗しました")
      end
    end
    describe "ログアウト" do
      it "ログアウトできること" do
        login_as(general_user)
        visit root_path
        find('button.navbar-toggler').click
        click_on "ログアウト"
        expect(current_path).to eq root_path
        expect(page).to have_content("ログアウトしました")
        expect(page).to have_link("ログイン", href: login_path)
      end
    end
  end
  describe "管理者ユーザー" do
    describe "ログイン" do
      it "ログイン失敗時にフラッシュメッセージが表示される" do
        visit admin_login_path
        fill_in "メールアドレス", with: admin_user.email
        click_button "ログイン"
        expect(page).to have_content("ログインに失敗しました")
      end
      it "通常ユーザーはログインできない" do
        visit admin_login_path
        fill_in "メールアドレス", with: general_user.email
        fill_in "パスワード", with: "password"
        click_on "ログイン"
        expect(current_path).to eq root_path
        expect(page).to have_content("管理者限定のため利用不可です")
      end
    end
    describe "ログアウト" do
      it "ログアウトできること" do
        login_as(admin_user)
        visit admin_root_path
        click_on "ログアウト"
        expect(current_path).to eq admin_login_path
        expect(page).to have_content("ログアウトしました")
      end
    end
  end
end
