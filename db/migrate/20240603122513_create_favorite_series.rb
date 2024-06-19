class CreateFavoriteSeries < ActiveRecord::Migration[7.1]
  def change
    create_table :favorite_series do |t|
      t.references :user, null: false, foreign_key: true
      t.references :serie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
