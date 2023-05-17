class Post < ApplicationRecord

  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # postsテーブルから中間テーブルに対する関連付け
  has_many :post_tag_relations, dependent: :destroy
  # postsテーブルから中間テーブルを介してTagsテーブルへの関連付け
  has_many :tags, through: :post_tag_relations, dependent: :destroy

  has_many_attached :images # 複数画像アップロード
  validate :image_presence # 必ず1枚の画像をアップロードする
  FILE_NUMBER_LIMIT = 5
  validate :validate_number_of_files

  validates :furniture_name, presence: true, length: { maximum: 17 }
  validates :caption, length: { maximum: 2000 }

  validates :tag_ids, presence: true

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

  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, post_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, post_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def self.search(search)
    if search != ""
      Post.where('furniture_name LIKE(?) OR caption LIKE(?)', "%#{search}%", "%#{search}%")
    else
      Post.all
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
