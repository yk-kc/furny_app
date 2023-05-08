class Category < ApplicationRecord
  has_ancestry
  has_many :posts, dependent: :destroy

  # 親カテゴリの一覧
  PARENT_CATEGORIES = %w(
    ソファ
    チェア・椅子
    テーブル
    デスク・机
    収納家具
    キッチン収納・食器棚
    テレビボード・テレビ台
    ハンガーラック・コートハンガー
    玄関収納・小物
    ライト・照明
    ベッド
    寝具・タオル
    ミラー・ドレッサー
    ラグ・カーペット
    クッション
    時計
    花器・プランター・グリーン
    オブジェ・アート
    食器・テーブルウェア
    雑貨・その他インテリア家具
  ).freeze

  # 子カテゴリの一覧
  CHILD_CATEGORIES = %w(
    レッド
    ブルー
    グリーン
    イエロー
    オレンジ
    ピンク
    パープル
    ベージュ・アイボリー
    ダークブラウン
    ウォールナットブラウン
    ミディアムブラウン
    ライトブラウン
    ブラック
    グレー
    ホワイト
    クリア
    ゴールド
    シルバー
  ).freeze
end
