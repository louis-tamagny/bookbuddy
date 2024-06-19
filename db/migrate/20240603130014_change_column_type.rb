class ChangeColumnType < ActiveRecord::Migration[7.1]
  def change
    rename_column :books, :type, :book_type
  end
end
