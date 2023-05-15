class Notification < ApplicationRecord
  # 新しい通知からデータを取得できる
  default_scope -> { order(created_at: :desc) }

  # optional: trueはnilを許可するもの
  belongs_to :post, optional: true
  belongs_to :post_comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
end
