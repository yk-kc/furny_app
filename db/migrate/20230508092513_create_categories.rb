class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|

      t.string :name, null: false
      t.string :ancestry
      t.index :ancestry

      t.timestamps
    end
  end
end
