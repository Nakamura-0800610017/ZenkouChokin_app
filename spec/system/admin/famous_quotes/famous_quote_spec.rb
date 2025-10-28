require 'rails_helper'

RSpec.describe '管理画面/名言', type: :system do
  let!(:admin_user) { create(:user, :admin) }
  let!(:quote1) { create(:famous_quote, created_at: DateTime.new(2025, 10, 1)) }
  let!(:quote2) { create(:famous_quote, created_at: DateTime.new(2025, 10, 2)) }

  before do
    login_as_admin(admin_user)
    visit admin_root_path
  end
  describe "名言一覧表示" do
    it "名言一覧が正しく表示されている" do
      click_on "名言一覧"
      quotes = [ quote1, quote2 ]
      quotes.each do |quote|
        expect(page).to have_content("名言一覧")
        expect(page).to have_content(quote.content)
        expect(page).to have_content(quote.author)
      end
    end
    describe "名言登録" do
      it "名言が登録できること" do
        click_on "名言登録"
        expect(current_path).to eq new_admin_famous_quote_path
        fill_in "本文", with: "テスト本文"
        fill_in "人物", with: "テスト人物"
        click_on "登録"
        expect(current_path).to eq admin_famous_quotes_path
        expect(page).to have_content("名言を作成しました")
        expect(page).to have_content("テスト本文")
      end
    end
    describe "名言編集" do
      it "名言を編集できること" do
        click_on "名言一覧"
        find("#button-edit-#{quote1.id}").click
        expect(current_path).to eq edit_admin_famous_quote_path(quote1)
        fill_in "本文", with: "変更後本文"
        fill_in "人物", with: "変更後人物"
        click_on "更新"
        expect(current_path).to eq admin_famous_quotes_path
        expect(page).to have_content("投稿を更新しました")
        expect(page).to have_content("変更後本文")
      end
    end
    describe "名言削除", js: true do
      it "名言を削除できること" do
        click_on "名言一覧"
        accept_confirm { find("#button-delete-#{quote1.id}").click }
        expect(page).to have_content("名言を削除しました")
        expect(page).to have_no_content(quote1.content)
      end
    end
  end
end
