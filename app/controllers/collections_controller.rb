class CollectionsController < ApplicationController
  before_action :set_collection, only: [:update, :favorite, :read]
  skip_before_action :verify_authenticity_token, only: [:create]

  def update
    @collection.update(collection_params)
    redirect_to book_path(@collection.book)
  end

  def create
    @book = Book.find(params[:book_id])
    @collection = Collection.create(book: @book, user: current_user)
    respond_to do |format|
      format.html { redirect_to book_path(@book)}
      format.text { render partial: 'partials/books/book_card', locals: {book: @book, collection: @collection}, formats: [:html] }
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @collection = Collection.find_by(book: @book, user_id: current_user)
    @collection.destroy
    redirect_to book_path(@book)
  end

  def favorite
    @collection.is_favorited = !@collection.is_favorited
    if @collection.save
      respond_to do |format|
        format.html
        format.text { render partial: 'partials/collections/favorite_button', locals: {collection: @collection}, formats: [:html] }
      end
    else
      render json: {error: 'temporary error message'}, status: :unprocessable_entity
    end
  end

  def read
    @collection.is_read = !@collection.is_read
    if @collection.save
      respond_to do |format|
        format.html do
          render json: {message: 'The favorite status has been updated'}, status: :accepted
        end
        format.text { render partial: 'partials/collections/read_button', locals: { collection: @collection }, formats: [:html] }
      end
    else
      render json: {error: 'temporary error message'}, status: :unprocessable_entity
    end
  end

  private

  def collection_params
    params.require(:collection).permit(:comment)
  end

  def set_collection
    @collection = Collection.find(params[:id])
  end
end
