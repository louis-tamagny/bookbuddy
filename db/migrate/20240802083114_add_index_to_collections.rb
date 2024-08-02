class AddIndexToCollections < ActiveRecord::Migration[7.1]
  def change
    add_index :collections, [:book_id, :user_id], unique: true
  end
end
