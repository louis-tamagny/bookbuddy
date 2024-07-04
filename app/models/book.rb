class Book < ApplicationRecord

  TYPES = ['Roman', 'Manga', 'BD', 'Poesie']

  # Active Records Associations
  belongs_to :serie, optional: true
  has_many :book_genres, dependent: :destroy
  has_many :genres, through: :book_genres
  has_many :collections
  has_many :users, through: :collections

  has_one_attached :cover_img

  # ActiveRecords Validations
  validates :title, presence: true, uniqueness: true
  validates :book_type, presence: true, inclusion: { in: Book::TYPES }

  # Search scopes
  scope :with_user_id, lambda{ |user_id| joins(:users).where(users: {id: user_id}) }
  scope :filtered_by_genre, lambda{ |genres| joins(:genres).where(genres: {name: genres}) }
  scope :favorite_books, -> { where(collections: { is_favorited: true})}
  scope :read_books, -> { where(collections: {is_read: 'true'}) }

  # PGSearch Methods
  include PgSearch::Model
  multisearchable against: [:title, :author, :illustrator]

  pg_search_scope :global_search,
    against: [:title, :author, :illustrator],
    associated_against: {serie: :name},
    using: {trigram: {}, tsearch: {prefix: true}}
end
