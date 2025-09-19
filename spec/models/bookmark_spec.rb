require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "レコード作成" do
    it "ユーザーとポストの組み合わせが一意だと作成できる" do
      bookmark = build(:bookmark)
      expect(bookmark).to be_valid
    end
    it "ユーザーとポストの組み合わせが一意じゃないと作成できない" do
      bookmark = create(:bookmark)
      new_bookmark = build(:bookmark, user: bookmark.user, post: bookmark.post)
      new_bookmark.valid?
      expect(new_bookmark.errors[:user_id]).to include("はすでに存在します")
    end
  end
  describe "ボーナスポイント" do
    it "ブックマークされるとボーナスポイントがつく" do
      user = create(:user)
      post = create(:post, user: user, point: 10)
      bookmark = create(:bookmark, post: post)
      expect(user.user_point.total_points).to eq(11)
    end
    it "ブックマーク削除でボーナスポイントが減る" do
      user = create(:user)
      post = create(:post, user: user, point: 10)
      bookmark = create(:bookmark, post: post)
      expect { bookmark.destroy }.to change { user.user_point.reload.total_points }.by(-1)
    end
  end
end
