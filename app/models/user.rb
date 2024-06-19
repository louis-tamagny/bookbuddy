class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :collections, dependent: :destroy
  has_many :favorite_series, dependent: :destroy
  has_many :books, through: :collections
  has_many :series, through: :favorite_series, source: :serie
  has_many :books_series, through: :books, source: :serie

  validates :nickname, presence: true
end
