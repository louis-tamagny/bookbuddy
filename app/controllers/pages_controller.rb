class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:splash_screen]
  def home
    @favorite_books = current_user.books.favorite_books
  end

  def splash_screen
  end
end
