require 'rails_helper'

RSpec.describe '管理画面/投稿', type: :system do
  let!(:admin_user) { create(:user, :admin) }
  let!(:post1) { create(:post, created_at: DateTime.new(2025, 10, 1)) }
  let!(:post2) { create(:post, created_at: DateTime.new(2025, 10, 2)) }
  let!(:post3) { create(:post, created_at: DateTime.new(2025, 10, 3)) }
  let!(:post4) { create(:post, created_at: DateTime.new(2025, 10, 4)) }

  before do
    login_as_admin(admin_user)
    visit admin_root_path
  end
  describe "投稿一覧表示" do
    it "『行い』一覧が正しく表示されている" do
      posts = [ post1, post2, post3, post4 ]
      posts.each do |post|
        expect(page).to have_content("『行い』一覧")
        expect(page).to have_content(post.body)
        expect(page).to have_content(post.post_type)
        expect(page).to have_content(post.point)
        expect(page).to have_content(post.user.user_name)
      end
    end
    describe "投稿編集" do
      it "投稿を編集できること" do
        find("#button-edit-#{post1.id}").click
        expect(current_path).to eq edit_admin_post_path(post1)
        select "善行", from: "種類"
        fill_in "本文", with: "変更後本文"
        select "10", from: "善行ポイント"
        click_on "更新"
        expect(current_path).to eq(admin_root_path)
        expect(page).to have_content("投稿を更新しました")
        expect(page).to have_content("変更後本文")
      end
    end
    describe "投稿削除" , js: true do
      it "投稿を削除できること" do
        accept_confirm { find("#button-delete-#{post1.id}").click }
        expect(page).to have_content("投稿を削除しました")
        expect(page).to have_no_content(post1.body)
      end
    end
  end
end
