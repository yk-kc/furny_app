class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  has_one_attached :profile_image

  validates :name, presence: true, length: { maximum: 10 }
  validates :username, uniqueness: true,
      length: { minimum: 6, maximum: 14 },
      format: { with: /[a-z\d]{6,}/i, message: "は半角英数字を6文字以上含む必要があります" }

  # usernameの頭に自動で「@」をつける
  before_create{ self.username= "@" + username}

  # ゲストログイン機能
  def self.guest
    find_or_create_by!(name: 'guestuser' ,username: 'guestuser', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64 # ランダムな文字列を生成するRubyのメソッド
      user.name = "guestuser"
      user.username = "guestuser"
    end
  end

  def get_profile_image(width, height)
      unless profile_image.attached?
        file_path = Rails.root.join("app/assets/images/default-image.jpg")
        profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
      end
      profile_image.variant(resize: "#{width}x#{height}^", gravity: "center", crop: "#{width}x#{height}+0+0").processed
  end

  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  def create_notification_follow!(current_user)
    # すでにフォローされているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    # フォローされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def self.search(search)
    if search != ""
      User.where('name LIKE(?) OR username LIKE(?)', "%#{search}%", "%#{search}%")
    else
      User.all
    end
  end


end
