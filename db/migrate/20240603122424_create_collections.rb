class CreateCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :collections do |t|
      t.boolean :is_read
      t.boolean :is_favorited
      t.text :comment
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
