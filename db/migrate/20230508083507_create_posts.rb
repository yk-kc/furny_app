class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :category_id, null: false
      t.string :furniture_name, null: false
      t.text :caption, null: false
      t.timestamps
    end
  end
end
