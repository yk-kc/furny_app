class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  has_many_attached :images # 複数画像アップロード
  validate :image_presence # 必ず1枚の画像をアップロードする
  FILE_NUMBER_LIMIT = 5
  validate :validate_number_of_files

  validates :furniture_name, presence: true
  validates :caption, length: { maximum: 2000 }

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
    errors.add(:images, "1枚以上選択してください。") unless images.attached?
  end

  def validate_number_of_files
    return if images.length <= FILE_NUMBER_LIMIT
    errors.add(:images, "添付できる画像は#{FILE_NUMBER_LIMIT}件までです。")
  end

end
