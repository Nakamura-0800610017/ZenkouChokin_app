require "rails_helper"

RSpec.describe "共通系", type: :system do
  context "ログイン前" do
    before do
      visit root_path
    end
    it "ヘッダーが正しく表示されていること" do
      find('button.navbar-toggler').click
      expect(page).to have_selector("button[data-bs-target='#modal_how_to']", text: "使い方")
      expect(page).to have_link("ランキング", href: user_points_path)
      expect(page).to have_link("善行一覧", href: posts_path)
      expect(page).to have_link("『行い』を捧げる", href: new_post_path)
      expect(page).to have_link("ログイン", href: login_path)
    end
    it "フッターが正しく表示されていること" do
      expect(page).to have_selector("button[data-bs-target='#modal_privacy_policy']", text: "プライバシーポリシー")
      expect(page).to have_selector("button[data-bs-target='#modal_terms']", text: "利用規約")
      expect(page).to have_link("お問い合わせ")
    end
  end

  context "ログイン後" do
    let(:user) { create(:user) }
    before do
      login_as(user)
      visit root_path
    end
    it "ヘッダーが正しく表示されていること" do
      find('button.navbar-toggler').click
      expect(page).to have_selector("button[data-bs-target='#modal_how_to']", text: '使い方')
      expect(page).to have_link("ランキング", href: user_points_path)
      expect(page).to have_link("『いいね』した善行", href: bookmarks_posts_path)
      expect(page).to have_link("善行一覧", href: posts_path)
      expect(page).to have_link("『行い』を捧げる", href: new_post_path)
      expect(page).to have_link("マイページ", href: user_path(user))
      expect(page).to have_button("ログアウト")
    end
  end
end
