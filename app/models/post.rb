class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  has_many_attached :images # 複数画像アップロード
  validate :image_presence # 必ず1枚の画像をアップロードする

  validates :furniture_name, presence: true
  validates :caption, presence: true, length: { maximum: 2000 }

  private

  def image_presence
    errors.add(:images, "at least one image is required") unless images.attached?
  end
end
