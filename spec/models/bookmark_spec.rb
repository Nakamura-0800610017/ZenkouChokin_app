require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "レコード作成" do
    context "ログインユーザーの場合" do
      let(:user) { create(:user) }
      let(:post) { create(:post) }
      it "ユーザーとポストの組み合わせが一意だと作成できる" do
        bookmark = build(:bookmark, user: user, post: post, session_id: nil)
        expect(bookmark).to be_valid
      end
      it "ユーザーとポストの組み合わせが一意じゃないと作成できない" do
        bookmark = create(:bookmark, user: user, post: post, session_id: nil)
        new_bookmark = build(:bookmark, user: user, post: post, session_id: nil)
        new_bookmark.valid?
        expect(new_bookmark.errors[:post_id]).to include("はすでに存在します")
      end
    end

    context "ゲスト（session_id）の場合" do
      let(:session_id) { SecureRandom.uuid }
      let(:post) { create(:post) }
      it "session_idとポストの組み合わせが一意だと作成できる" do
        bookmark = build(:bookmark, :guest, session_id: session_id, post: post)
        expect(bookmark).to be_valid
      end
      it "同一のsession_idとポストの組み合わせは作成できない" do
        bookmark = create(:bookmark, :guest, session_id: session_id, post: post)
        new_bookmark = build(:bookmark, :guest, session_id: session_id, post: post)
        new_bookmark.valid?
        expect(new_bookmark.errors[:post_id]).to include("はすでに存在します")
      end
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
