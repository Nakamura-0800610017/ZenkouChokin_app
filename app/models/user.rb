class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :password, length: { in: 6..18 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :user_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy
  has_one :user_point, dependent: :destroy

  after_create :create_user_point

  def own?(object)
    id == object&.user_id
  end

  private

  def create_user_point
    create_user_point(total_points: 0, user_rank: 0)
  end
end
