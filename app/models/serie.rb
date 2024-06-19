class Serie < ApplicationRecord
  STATUS = ['En cours', 'Terminée']

  # Active Records Associations
  has_many :favorite_series
  has_many :users, through: :favorite_series
  has_many :books

  # Active Records Validations
  validates :name, presence: true


  # Search scopes
  scope :with_user_id, lambda{ |user_id| joins(:favorite_series, :users).where(users: {id: user_id}) }

  # PGSearch Methods
  include PgSearch::Model
  multisearchable against: [:name]

  pg_search_scope :global_search,
    against: [:name],
    associated_against: {books: :title},
    using: {trigram: {}, tsearch: {prefix: true}}
end
