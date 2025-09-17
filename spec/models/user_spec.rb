require 'rails_helper'

RSpec.describe User, type: :model do
  describe "ローカルパスワードを利用する" do
    context "正常系" do
      it "すべての情報が入力されるとユーザー作成ができる" do
        user = build(:user)
        expect(user).to be_valid
      end
    end
    context "異常系" do
      it "入力箇所空欄で失敗" do
        user = build(:user)
        user.user_name = nil
        user.email = nil
        user.password = nil
        user.password_confirmation = nil
        user.valid?
        expect(user.errors[:user_name]).to include("を入力してください")
        expect(user.errors[:email]).to include("を入力してください")
        expect(user.errors[:password]).to include("を入力してください")
        expect(user.errors[:password_confirmation]).to include("を入力してください")
      end
      it "メールアドレス重複で失敗" do
        user1 = create(:user)
        user2 = build(:user)
        user2.email = user1.email
        user2.valid?
        expect(user2.errors[:email]).to include("はすでに存在します")
      end
      it "password5文字で失敗" do
        user = build(:user)
        user.password = "a" * 5
        user.valid?
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end
      it "password19文字で失敗" do
        user = build(:user)
        user.password = "a" * 19
        user.valid?
        expect(user.errors[:password]).to include("は18文字以内で入力してください")
      end
      it "password,password_confirmationが不一致で失敗" do
        user = build(:user)
        user.password_confirmation = "pass_word"
        user.valid?
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
      it "利用規約未同意で失敗" do
        user = build(:user)
        user.terms_of_service = false
        user.valid?
        expect(user.errors[:terms_of_service]).to include("を受諾してください")
      end
    end
  end
  describe "外部認証を利用する" do
    it "外部認証ユーザーはuser_nameだけで作成できる" do
      user = User.new(user_name: "oauth_user", authentications_attributes: [ { provider: "twitter", uid: "uid_#{SecureRandom.hex(6)}" } ])
      expect(user).to be_valid
    end
  end
  describe "ユーザー作成後" do
    it "ユーザーが作成されたとき、User_pointsレコードも作成される" do
      user = create(:user)
      expect(user.user_point).to be_present
      expect(user.user_point.total_points).to eq(0)
      expect(user.user_point.user_rank).to eq("nomal")
    end
    it "ユーザー作成時、modeとroleがデフォルト値である" do
      user = User.new(user_name: "user_name", email: "test@example.com", password: "password", password_confirmation: "password", terms_of_service: true)
      user.save!
      expect(user.mode).to eq("normal")
      expect(user.role).to eq("general")
    end
  end
  describe "依存削除" do
    it "ユーザー削除時、ユーザーポイントが消える" do
      user = create(:user)
      expect { user.destroy! }
        .to change(UserPoint, :count).by(-1)
    end
  end
end
