class BooksController < ApplicationController
  before_action :set_book, only: [:show, :update]

  def show
    @collection = Collection.find_by(book_id: @book.id, user: current_user)

    respond_to do |format|
      format.html
      format.text do
        @book = @book.find_by(book_params)
        render partial: "partials/books/book_card_choice",
        locals: {book: @book, collection: Collection.new},
        formats: [:html]
      end
    end
  end

  def index
    @books = Book.all.limit(30)

    if params[:query].present?
      @books = Book.global_search(params[:query]).limit(30)
    end

    unless (params[:owned].present? && params[:owned] == 'false')
      @books = @books.with_user_id(current_user.id)
    end

    if (params[:favorite].present? && params[:favorite] == 'true')
      @books = @books.favorite_books
    end

    if params[:genres].present? && params[:genres] != ""
      @books = @books.filtered_by_genre(params[:genres].split(' '))
    end

    @books = @books.includes(:genres, :serie, :cover_img_blob)
    @books = @books.order(created_at: :desc)
    @genres = Genre.all

    respond_to do |format|
      format.html
      format.text { render partial: "partials/index_list", locals: {books: @books}, formats: [:html] }
    end
  end

  def new
    unless params[:title]
      @book = @book || Book.new
      @book.genres.build
    else
      @book = Book.find_by(isbn: params[:isbn])

      unless @book
        @book = Book.create!(
          book_type: 'Roman',
          title: params[:title],
          author: params[:author],
          release: params[:release].size == 4 ? Date.new(params[:release].to_i) : Date.parse(params[:release]),
          edition: params[:edition],
          isbn: params[:isbn],
          cover_url: params[:cover_url]
        )
        @book.serie = Serie.create_or_find_by!(name: params[:serieNames][0]) if params[:serieNames].present?

        if params[:genres].present?
          genre = Genre.find_or_create_by!(name: params[:genres])
          @book.genres << genre unless @book.genres.include?(genre)
        end
      end
    end

    respond_to do |format|
      format.html
      format.text do
          render partial: "partials/books/book_card_choice",
            locals: {book: @book, collection: Collection.new},
            formats: [:html]
      end
    end
  end

  def update
    if @book.update(book_params) && params[:book][:genre_ids]
      params[:book][:genre_ids][1..].each do |genre_id|
        genre = Genre.find(genre_id)
        @book.genres << genre unless @book.genres.include?(genre)
      end
    end
  end

  def create
    @book = Book.from_BNF(book_params[:isbn])

    if @book.save
      render :new, :ok, notice: "The book has been created"
    else
      render :new, :unprocessable_entity, notice: "The book has not been created"
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def serie_params
    params.require(:serie).permit(:name)
  end

  def book_params
    params.require(:book).permit(
      :book_type,
      :title,
      :author,
      :illustrator,
      :serie_id,
      :serie_number,
      :description,
      :release,
      :edition,
      :cover_img,
      :isbn
    )
  end
end
