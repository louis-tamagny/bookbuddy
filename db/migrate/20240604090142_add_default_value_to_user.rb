class AddDefaultValueToUser < ActiveRecord::Migration[7.1]
  def up
    change_column_default :users, :public, false
  end

  def down
    change_column_default :users, :public, nil
  end
end
