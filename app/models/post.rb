class Post < ApplicationRecord
  validates :body, presence: true, length: { maximum: 140 }
  validates :point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -10, less_than_or_equal_to: 10 }
  enum post_type: { zenkou: 0, akugyou: 1 }

  belongs_to :user

  after_create :update_total_points
  after_destroy :update_total_points

  private

  def update_total_points
    user_point = user.user_point || user.create_user_point # 検証用アカウントを削除したら消しても良い
    user_point.total_points = user.posts.sum(:point)
    user_point.update_rank!
  end
end
