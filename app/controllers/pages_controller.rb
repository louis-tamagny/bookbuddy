class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:splash_screen]
  def home
  end

  def splash_screen
  end
end
