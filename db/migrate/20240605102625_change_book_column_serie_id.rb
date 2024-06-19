class ChangeBookColumnSerieId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :books, :serie_id, true
  end
end
