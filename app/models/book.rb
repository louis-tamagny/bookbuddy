require 'open-uri'
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
  scope :favorite_books, lambda{where(collections: { is_favorited: true})}
  scope :read_books, lambda{ where(collections: {is_read: 'true'}) }

  # PGSearch Methods
  include PgSearch::Model
  multisearchable against: [:title, :author, :illustrator]

  pg_search_scope :global_search,
    against: [:title, :author, :illustrator],
    associated_against: {serie: :name},
    using: {trigram: {}, tsearch: {prefix: true}}

  def self.from_ISBN(isbn)
    book = Book.find_by(isbn: isbn)
    
    unless book
      book = Book.from_BNF(isbn)
    end

    unless book
      book = Book.from_OL(isbn)
    end
    return book
  end

  def self.from_BNF(isbn)
    base_url = "http://catalogue.bnf.fr/api/SRU?version=1.2&operation=searchRetrieve&query=bib.isbn any \"#{isbn}\""
    begin
      file = URI.open(base_url)
      doc = Nokogiri::XML(file)
      nmsp = doc.collect_namespaces

      new_book = Book.new({
        title: doc.xpath("//mxc:datafield[@tag='200']/mxc:subfield[@code='a']", nmsp).text,
        book_type: 'Roman',
        author: doc.xpath("//mxc:datafield[@tag='200']/mxc:subfield[@code='f']", nmsp).text,
        release: Date.new(doc.xpath("//mxc:datafield[@tag='210']/mxc:subfield[@code='d']", nmsp).text.match(/(\d{4})/)[1].to_i),
        edition: doc.xpath("//mxc:datafield[@tag='210']/mxc:subfield[@code='c']", nmsp).text,
        cover_url: "https://catalogue.bnf.fr/couverture?appName=NE&idArk=#{
          doc.xpath("//srw:recordData/mxc:record", nmsp).attribute('id').value
        }&couverture=1&largeur=400&hauteur=600",
        isbn: isbn
      })

      unless doc.xpath("//mxc:datafield[@tag='225']/mxc:subfield[@code='a']", nmsp).text.empty?
        serie = Serie.create_or_find_by(name: doc.xpath("//mxc:datafield[@tag='225']/mxc:subfield[@code='a']", nmsp).text)
        new_book.serie = serie
        new_book.serie_number = doc.xpath("//mxc:datafield[@tag='225']/mxc:subfield[@code='v']", nmsp).text.to_i
        # serie_name: doc.xpath("//mxc:datafield[@tag='225']/mxc:subfield[@code='a']", nmsp).text,
        # serie_number: doc.xpath("//mxc:datafield[@tag='225']/mxc:subfield[@code='v']", nmsp).text,
      end

      new_book.save!

      return new_book
    rescue
      return nil
    end
  end

  def self.from_OL(isbn)
    base_url = "https://openlibrary.org/isbn/#{isbn}.json"
    begin

      file = URI.open(base_url).read
      doc = JSON.parse(file)
      new_book = Book.new(title: doc["title"])
      new_book.author = doc["by_statement"]
      unless new_book.author
        author_doc = JSON.parse(URI.open("https://openlibrary.org#{doc["authors"][0]["key"]}.json").read)
        new_book.author = author_doc["name"]
      end

      if doc["series"]
        serie = Serie.create_or_find_by(name: doc["series"][0].split(',')[0])
        new_book.serie = serie
      end

      new_book.book_type = "Roman"
      new_book.cover_url = doc["covers"] ? "https://covers.openlibrary.org/b/id/#{doc["covers"][0]}-M.jpg" : nil
      new_book.description = doc["description"] if (doc["description"])
      new_book.release = doc["publish_date"] if (doc["publish_date"])
      new_book.edition = doc["publishers"][0] if (doc["publishers"])
      new_book.isbn = isbn

      new_book.save!

      return new_book
    rescue
      return nil
    end
  end
end
