class Bookmark < ApplicationRecord

  belongs_to :user
  belongs_to :post

  # ロード中に２度以上連続で登録しようとすることを防ぐ。
  validates :user_id, uniqueness: { scope: :post_id }

end
