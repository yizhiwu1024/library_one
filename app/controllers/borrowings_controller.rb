class BorrowingsController < ApplicationController
  before_action :require_login
  before_action :set_borrowing, only: [:update]
  before_action :authorize_borrowing_access!, only: [:update]

  def index
    @borrowings = if current_user.admin?
                    Borrowing.includes(:book, :user).order(created_at: :desc)
                  else
                    current_user.borrowings.includes(:book).order(created_at: :desc)
                  end
  end

  def create
    if current_user.admin?
      return redirect_to book_path(params[:book_id]), alert: "Admins cannot create borrowings."
    end

    book = Book.find(params[:book_id])

    unless current_user.can_borrow_more?
      return redirect_to book_path(book), alert: "Borrowing limit reached (max 5 active books)."
    end

    unless book.available?
      return redirect_to book_path(book), alert: "This book is currently unavailable."
    end

    borrowing = nil

    Borrowing.transaction do
      book.lock!
      raise ActiveRecord::Rollback unless book.available?

      book.decrement!(:available_copies)
      borrowing = current_user.borrowings.create!(book: book)
    end

    if borrowing
      redirect_to borrowings_path, notice: "Book borrowed successfully."
    else
      redirect_to book_path(book), alert: "This book is currently unavailable."
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to book_path(book), alert: "Unable to borrow this book."
  end

  def update
    operation = params[:operation].to_s

    if operation == "renew"
      if @borrowing.renew!
        redirect_to borrowings_path, notice: "Borrowing renewed for 10 days."
      else
        redirect_to borrowings_path, alert: "Renewal is not allowed for this borrowing."
      end
    elsif operation == "return"
      if @borrowing.return_book!
        redirect_to borrowings_path, notice: "Book returned successfully."
      else
        redirect_to borrowings_path, alert: "Unable to return this book."
      end
    else
      redirect_to borrowings_path, alert: "Unsupported operation."
    end
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end

  def authorize_borrowing_access!
    return if current_user.admin?
    return if @borrowing.user_id == current_user.id

    redirect_to borrowings_path, alert: "You are not authorized to access this borrowing."
  end
end


