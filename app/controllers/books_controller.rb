class BooksController < ApplicationController
  before_action :require_login

  def index
    @query = params[:q]
    @books = Book.includes(:category).search(@query).order(:title)
  end

  def show
    @book = Book.find(params[:id])
  end
end

