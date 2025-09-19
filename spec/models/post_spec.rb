require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "フォーム項目" do
    context "正常系" do
      it "本文、ポイント、種類すべて入力で作成" do
        post = build(:post)
        expect(post).to be_valid
      end
    end
    context "異常系" do
      it "必須項目未入力で失敗" do
        post = build(:post)
        post.body = nil
        post.point = nil
        post.post_type = nil
        post.valid?
        expect(post.errors[:body]).to include("を入力してください")
        expect(post.errors[:point]).to include("を入力してください")
        expect(post.errors[:post_type]).to include("を入力してください")
      end
      it "善行でポイントがマイナスだと失敗" do
        post = build(:post)
        post.point = "-5"
        post.valid?
        expect(post.errors[:point]).to include("は1以上の値にしてください")
      end
      it "悪行でポイントがプラスだと失敗" do
        post = build(:post, :akugyou)
        post.point = "5"
        post.valid?
        expect(post.errors[:point]).to include("は-1以下の値にしてください")
      end
      it "本文文字数141字で失敗" do
        post = build(:post)
        post.body = "a" * 141
        post.valid?
        expect(post.errors[:body]).to include("は140文字以内で入力してください")
      end
    end
  end
  describe "トータルポイント更新" do
    it "Post作成でtotal_pointsが更新される" do
      user = create(:user)
      post = build(:post, user: user, point: 5)
      expect { post.save! }
        .to change { user.user_point.reload.total_points }.by(5)
    end
    it "Postが削除されるとtotal_pointが更新される" do
      user = create(:user)
      post = create(:post, user: user, point: 5)
      expect { post.destroy! }
        .to change { user.user_point.reload.total_points }.by(-5)
    end
  end
end
