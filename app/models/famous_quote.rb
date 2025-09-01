class FamousQuote < ApplicationRecord
  validates :content, presence: true, length: { maximum: 500 }
  validates :author,  presence: true, length: { maximum: 140 }
end
