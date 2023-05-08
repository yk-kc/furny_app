# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 親カテゴリを作成
Category.create!(name: 'インテリア', ancestry: nil)

Category::PARENT_CATEGORIES.each do |parent|
  # 親カテゴリに属する子カテゴリを作成
  parent_category = Category.create!(name: parent, ancestry: '1')

  Category::CHILD_CATEGORIES.each do |child|
    # 子カテゴリを作成し、親カテゴリに紐づける
    child_category = parent_category.children.create!(name: child)
  end
end
