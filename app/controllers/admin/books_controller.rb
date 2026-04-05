module Admin
  class BooksController < BaseController
    before_action :set_book, only: %i[show edit update destroy]

    def index
      @books = Book.includes(:category).order(:title)
    end

    def show; end

    def new
      @book = Book.new
    end

    def create
      @book = Book.new(book_params)

      if @book.save
        redirect_to admin_book_path(@book), notice: "Book created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @book.update(book_params)
        redirect_to admin_book_path(@book), notice: "Book updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @book.destroy
        redirect_to admin_books_path, notice: "Book deleted successfully."
      else
        redirect_to admin_books_path, alert: @book.errors.full_messages.to_sentence
      end
    end

    private

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :author, :isbn, :description, :total_copies, :available_copies, :category_id)
    end
  end
end

