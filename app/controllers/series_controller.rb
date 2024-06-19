class SeriesController < ApplicationController
  before_action :set_serie, only: [:show]

  def show
    @userBook = current_user.books.group(:serie_id).count
  end

  def index
    @user_favorite_series = current_user.series
    @user_books_series = current_user.books_series
    @series = Serie.all
  end
end

private

def set_serie
  @serie = Serie.find(params[:id])
end
