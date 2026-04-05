require "test_helper"

class BorrowingFlowTest < ActionDispatch::IntegrationTest
  test "member borrows available book from nested route" do
    user = users(:member)
    book = books(:ruby_book)

    sign_in_as(user)

    assert_difference "Borrowing.count", 1 do
      post book_borrowings_path(book)
    end

    assert_redirected_to borrowings_path
    book.reload
    assert_equal 3, book.available_copies
  end

  test "member cannot borrow unavailable book" do
    user = users(:member)
    book = books(:math_book)

    sign_in_as(user)

    assert_no_difference "Borrowing.count" do
      post book_borrowings_path(book)
    end

    assert_redirected_to book_path(book)
  end

  test "admin cannot create borrowing" do
    admin = users(:admin)
    book = books(:ruby_book)

    sign_in_as(admin)

    assert_no_difference "Borrowing.count" do
      post book_borrowings_path(book)
    end

    assert_redirected_to book_path(book)
  end
end

