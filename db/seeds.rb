# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name:  "yu",
             username: "yuu415",
             email: "yu415@gmail.com",
             password:  "111111",
             password_confirmation: "111111",
             admin: true)

category_lists = ["ソファ", "チェア・椅子", "テーブル", "デスク", "収納家具", "キッチン収納・食器棚", "テレビボード", "ハンガーラック", "玄関収納・小物", "ライト・照明", "ベッド", "寝具・タオル", "ミラー・ドレッサー", "ラグ・カーペット", "クッション", "時計", "花器・プランター・グリーン", "オブジェ・アート", "食器・テーブルウェア", "雑貨・その他インテリア家具"]
for i in category_lists do
  Category.find_or_create_by!(
    name: i
  )
end
