class Bookmark < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post

  validates :post_id, presence: true
  validate :user_or_session_present

  after_create :update_bookmark_bonus
  after_destroy :update_bookmark_bonus

  def user_or_session_present
    if user_id.blank? && session_id.blank?
      errors.add(:base, "『いいね』に失敗しました")
    end
  end

  def update_bookmark_bonus
    post.user.user_point.update_total_points!
  end
end
