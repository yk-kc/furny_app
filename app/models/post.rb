class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  has_many_attached :images # 複数画像アップロード
  validate :image_presence # 必ず1枚の画像をアップロードする

  validates :furniture_name, presence: true
  validates :caption, presence: true, length: { maximum: 2000 }

  # 引数で渡されたユーザidがFavoritesテーブル内に存在（exists?）するかどうかを調べる
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 引数で渡されたユーザidがbookmarksテーブル内に存在（exists?）するかどうかを調べる
  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  def get_image(width, height)
      images.map do |image| # 複数あるimageをひとつずつ取り出してサイズ適用できるようにする
        image.variant(resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0").processed
      end
  end

  private

  def image_presence
    errors.add(:images, "at least one image is required") unless images.attached?
  end
end
