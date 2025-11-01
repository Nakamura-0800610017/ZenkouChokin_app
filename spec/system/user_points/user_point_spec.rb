require 'rails_helper'

RSpec.describe "ランキングページ", type: :system do
  let(:user) { create(:user) }
  let(:focus_user) { create(:user, :focus) }
  describe "表示" do
    it "表示できる" do
      login_as user
      find('button.navbar-toggler').click
      click_on "ランキング"
      expect(current_path).to eq user_points_path
    end
    it "集中モードのユーザーは閲覧できない" do
      login_as(focus_user)
      visit user_points_path
      expect(current_path).to eq user_path(focus_user.id)
      expect(page).to have_content("集中モードのため表示できないページです")
    end
  end
end
