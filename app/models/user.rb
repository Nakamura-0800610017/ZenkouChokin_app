class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :user_name, presence: true, length: { maximum: 255 }

  with_options if: :using_local_password? do
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { in: 6..18 }, confirmation: true
    validates :password_confirmation, presence: true
    validates :terms_of_service, acceptance: true, on: :create
  end

  validates :reset_password_token, uniqueness: true, allow_nil: true
  enum :mode, { normal: 0, focus: 1 }
  enum :role, { general: 0, admin: 1 }


  has_many :posts, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_one :user_point, dependent: :destroy
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

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

  def using_local_password?
    authentications.blank?
  end
end
