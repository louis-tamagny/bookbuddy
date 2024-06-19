class CreateSeries < ActiveRecord::Migration[7.1]
  def change
    create_table :series do |t|
      t.string :name
      t.integer :books_total
      t.string :status

      t.timestamps
    end
  end
end
