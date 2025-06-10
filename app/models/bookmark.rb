class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }

  after_create :update_bookmark_bonus
  after_destroy :update_bookmark_bonus

  def update_bookmark_bonus
    post.user.user_point.update_total_points!
  end
end
