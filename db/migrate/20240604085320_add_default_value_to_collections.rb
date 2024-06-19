class AddDefaultValueToCollections < ActiveRecord::Migration[7.1]
  def up
    change_column_default :collections, :is_read, false
    change_column_default :collections, :is_favorited, false
  end

  def down
    change_column_default :collections, :is_read, nil
    change_column_default :collections, :is_favorited, nil
  end
end
