require 'rails_helper'

RSpec.describe UserPoint, type: :model do
  describe "ランク計算" do
    it "投稿で合計ポイントが25に到達するとランクアップする" do
      user = create(:user)
      create_list(:post, 3, user: user, point: 8)
      expect(user.user_point.reload.user_rank).to eq("normal")
      expect { create(:post, user: user, point: 1) }
        .to change { user.user_point.reload.user_rank }.from("normal").to("danka")
    end
    it "投稿で合計ポイントが25を下回るとランクダウンする" do
      user = create(:user)
      create_list(:post, 5, user: user, point: 5)
      expect(user.user_point.reload.user_rank).to eq("danka")
      expect { create(:post, :akugyou, user: user) }
        .to change { user.user_point.reload.user_rank }.from("danka").to("normal")
    end
  end
end
