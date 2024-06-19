class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :serie_number
      t.string :type
      t.string :cover_url
      t.text :description
      t.string :isbn
      t.date :release
      t.string :author
      t.string :illustrator
      t.string :edition
      t.string :illustrations
      t.references :serie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
