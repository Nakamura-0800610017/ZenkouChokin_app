require 'rails_helper'

RSpec.describe '投稿', type: :system do
  let!(:user1) { create(:user) }
  let(:post1) { create(:post, :zenkou, user: user1, created_at: DateTime.new(2025, 10, 1)) }
  let(:post2) { create(:post, :zenkou, created_at: DateTime.new(2025, 10, 2)) }

  describe "投稿のCRUD" do
    describe "投稿の一覧表示" do
      context "基本表示" do
        it "正しく表示されていること" do
          post1
          post2
          posts = [ post1, post2 ]
          visit root_path
          find('button.navbar-toggler').click
          click_on "善行一覧"
          expect(current_path).to eq posts_path
          posts.each do |post|
            expect(page).to have_content(post.body)
            expect(page).to have_content(I18n.t("default.user_rank.#{post.user.user_point.user_rank}"))
            expect(page).to have_content(post.user.user_name)
          end
        end
        it "投稿がない場合は専用メッセージが表示されること" do
          visit root_path
          find('button.navbar-toggler').click
          click_on "善行一覧"
          expect(current_path).to eq posts_path
          expect(page).to have_content("投稿がありません")
        end
      end
      context "ページネーション" do
        it "投稿が20件以下のときはページリンクがない" do
          create_list(:post, 20)
          visit posts_path
          expect(page).to have_no_selector(".pagination")
        end
        it "21件以上あるときはページリンクがある" do
          create_list(:post, 21)
          visit posts_path
          expect(page).to have_selector(".pagination")
        end
      end
    end
    describe "投稿の作成" do
      context "ログインしていない場合" do
        it "ログイン画面にリダイレクト" do
          visit new_post_path
          expect(current_path).to eq login_path
          expect(page).to have_content("ログインしてください")
        end
      end
      context "ログイン済みの場合" do
        before do
          login_as(user1)
          visit new_post_path
        end
        it "投稿が作成できる" do
          select "善行", from: "type_select_box"
          fill_in "本文", with: "テスト本文"
          select "10", from: "point_select_box"
          click_on "捧げる"
          expect(current_path).to eq root_path
          expect(page).to have_content("投稿を作成しました")
        end
        it "投稿が作成できない" do
          select "善行", from: "type_select_box"
          select "10", from: "point_select_box"
          click_on "捧げる"
          expect(page).to have_content("投稿の作成に失敗しました")
          expect(page).to have_content("本文を入力してください")
        end
        it "種類によって善行ポイントが変化する", js: true do
          select "善行", from: "type_select_box"
          expect(page).to have_select("point_select_box", options: (1..10).map(&:to_s))
          select "悪行", from: "type_select_box"
          expect(page).to have_select("point_select_box", options: (-10..-1).to_a.reverse.map(&:to_s))
        end
      end
    end
    describe "投稿の編集" do
      context "ログインしていない場合" do
        it "ログイン画面にリダイレクト" do
          post1
          visit edit_post_path(post1)
          expect(current_path).to eq login_path
          expect(page).to have_content("ログインしてください")
        end
      end
      context "ログイン済みの場合" do
        before do
          post1
          post2
          login_as(user1)
          visit posts_path
        end
        context "自分の投稿" do
          it "更新ができる" do
            find("#button-edit-#{post1.id}").click
            expect(current_path).to eq edit_post_path(post1.id)
            fill_in "本文", with: "更新後本文"
            click_on "更新"
            expect(current_path).to eq root_path
            expect(page).to have_content("投稿を更新しました")
          end
          it "更新ができない" do
            find("#button-edit-#{post1.id}").click
            expect(current_path).to eq edit_post_path(post1.id)
            fill_in "本文", with: " "
            click_on "更新"
            expect(page).to have_content("投稿の更新に失敗しました")
            expect(page).to have_content("本文を入力してください")
          end
        end
        context "他人の投稿" do
          it "更新ボタンが表示されない" do
            expect(page).to have_no_selector("#button-edit-#{post2.id}")
          end
        end
      end
    end
    describe "投稿の削除" do
      context "自分の投稿" do
        it "削除できること", js: true do
          post1
          login_as(user1)
          visit posts_path
          accept_confirm { find("#button-delete-#{post1.id}").click }
          expect(page).to have_content("投稿を削除しました")
        end
      end
      context "他人の投稿" do
        it "削除ボタンが表示されない" do
          post2
          login_as(user1)
          visit posts_path
          expect(page).to have_no_selector("#button-delete-#{post2.id}")
        end
      end
    end
    describe "ブックマーク一覧" do
      before do
        post2
        login_as(user1)
      end
      it "ブックマークした一覧が表示される" do
        visit posts_path
        find("#bookmark-button-for-post-#{post2.id}").click
        visit bookmarks_posts_path
        expect(page).to have_content(post2.body)
      end
    end
  end
end
