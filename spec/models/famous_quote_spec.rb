require 'rails_helper'

RSpec.describe FamousQuote, type: :model do
  describe "文字数制限" do
    it "文字数制限オーバーで作成不可" do
      quote = create(:famous_quote)
      quote.content = "a" * 501
      quote.author = "b" * 141
      quote.valid?
      expect(quote.errors[:content]).to include("は500文字以内で入力してください")
      expect(quote.errors[:author]).to include("は140文字以内で入力してください")
    end
  end
end
