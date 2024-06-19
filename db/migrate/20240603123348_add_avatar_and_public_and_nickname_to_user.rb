class AddAvatarAndPublicAndNicknameToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :avatar, :string
    add_column :users, :public, :boolean
    add_column :users, :nickname, :string
  end
end
