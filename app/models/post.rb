class Post < ApplicationRecord
    validates :body, presence: true, length: { maximum: 140 }
    validates :point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -10, less_than_or_equal_to: 10 }

    belongs_to :user
end
