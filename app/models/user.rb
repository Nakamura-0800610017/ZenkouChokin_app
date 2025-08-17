class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :user_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { in: 6..18 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :terms_of_service, acceptance: true, on: :create

  has_many :posts, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_one :user_point, dependent: :destroy

  after_create :create_user_point_record

  def own?(object)
    id == object&.user_id
  end

  def create_user_point_record
    create_user_point(total_points: 0, user_rank: 0)
  end

  def bookmark(post)
  bookmark_posts << post
end

def unbookmark(post)
  bookmark_posts.destroy(post)
end

def bookmark?(post)
  bookmark_posts.include?(post)
end
end
