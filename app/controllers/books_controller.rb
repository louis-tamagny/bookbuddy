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
    @books = Book.all

    if params[:query].present?
      @books = Book.global_search(params[:query])
    end

    unless (params[:my].present? && params[:my] == 'false')
      @books = @books.with_user_id(current_user.id)
    end

    if (params[:favorite].present? && params[:favorite] == 'true')
      @books = @books.favorite_books(params[:favorite], current_user.id)
    end

    if params[:genres].present? && params[:genres] != ""
      @books = @books.filtered_by_genre(params[:genres].split(' '))
    end

    @books = @books.includes(:serie, :cover_img_blob)
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

        # Un seul genre est ajouté pour l'instant, ne sachant pas le format de genres multiples
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
    # je vérifie si le livre existe déjà avec son titre
    @book = Book.find_by(title: book_params[:title])

    # si le livre n'existe pas, je tente de créer un nouveau livre
    unless @book
      @book = Book.new(book_params)
      @book.release = Date.new(book_params[:release].to_i)

      # je tente de créer la série voulue par l'auteur
      if serie_params[:name] != ''
        @serie = Serie.create_or_find_by!(serie_params)
        @book.serie = @serie
      end

      @book.save
    end

    # je crée une nouvelle collection entre l'utilisateur et le book qui vient d'être créer
    if @book.id
      # je crée les associations livre - genre
      params[:book][:genre_ids][1..].each do |genre_id|
        genre = Genre.find(genre_id)
        @book.genres << genre unless @book.genres.include?(genre)
      end

      @collection = Collection.new(user: current_user, book: @book)
      if @collection.save
        redirect_to new_book_path
      end
    else
      render :new, status: :unprocessable_entity
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
