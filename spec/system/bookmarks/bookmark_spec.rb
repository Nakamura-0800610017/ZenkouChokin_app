require 'rails_helper'

RSpec.describe 'ブックマーク', type: :system, js: true do
  let(:user) { create(:user) }
  let!(:post) { create(:post, :zenkou) }

  context "ログインユーザーの場合" do
    let!(:bookmark) { create(:bookmark, user: user, post: post) }
    it "ブックマークの削除ができる" do
      login_as(user)
      visit bookmarks_posts_path
      find("#unbookmark-button-for-post-#{post.id}").click
      expect(page).to have_selector("#bookmark-button-for-post-#{post.id}")
    end
  end

  context "ゲストユーザーの場合" do
    it "ブックマークの作成ができる" do
      visit posts_path
      find("#guest-bookmark-button-for-post-#{post.id}").click
      expect(page).to have_selector("#guest-unbookmark-button-for-post-#{post.id}")
    end
    it "ブックマークの削除ができる" do
      visit posts_path
      find("#guest-bookmark-button-for-post-#{post.id}").click
      find("#guest-unbookmark-button-for-post-#{post.id}").click
      expect(page).to have_selector("#guest-bookmark-button-for-post-#{post.id}")
    end
  end
end
