class Post < ApplicationRecord
  validates :body, presence: true, length: { maximum: 140 }
  validates :point, presence: true
  validates :point,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 },
    if: :zenkou?

  validates :point,
    numericality: { only_integer: true, greater_than_or_equal_to: -10, less_than_or_equal_to: -1 },
    if: :akugyou?
  validates :post_type, presence: true
  enum :post_type, { zenkou: 0, akugyou: 1 }

  belongs_to :user
  has_many :bookmarks, dependent: :destroy

  after_create :update_post_points
  after_destroy :update_post_points

  private

  def update_post_points
    user.user_point.update_total_points!
  end
end
