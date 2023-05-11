class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  has_many_attached :images # 複数画像アップロード
  validate :image_presence # 必ず1枚の画像をアップロードする

  validates :furniture_name, presence: true
  validates :caption, presence: true, length: { maximum: 2000 }


  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def get_image(width, height)
      # unless images.attached?
      #   file_path = Rails.root.join("app/assets/images/default-image.jpg")
      #   images.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
      # end

      images.map do |image|
        image.variant(resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0").processed
      end
  end

  private

  def image_presence
    errors.add(:images, "at least one image is required") unless images.attached?
  end
end
