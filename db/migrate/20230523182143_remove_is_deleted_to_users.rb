class RemoveIsDeletedToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :is_deleted
  end
end
