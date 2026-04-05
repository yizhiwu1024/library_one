require "test_helper"

class BorrowingTest < ActiveSupport::TestCase
  test "renew extends due date by ten days once" do
    borrowing = borrowings(:active_borrowing)
    original_due_on = borrowing.due_on

    assert borrowing.renew!
    borrowing.reload

    assert_equal original_due_on + 10.days, borrowing.due_on
    assert_equal 1, borrowing.renewal_count
    assert_not borrowing.renew!
  end

  test "return marks borrowing returned and increases stock" do
    borrowing = borrowings(:active_borrowing)
    book = borrowing.book
    previous_available = book.available_copies

    assert borrowing.return_book!

    borrowing.reload
    book.reload

    assert borrowing.returned?
    assert_equal previous_available + 1, book.available_copies
  end
end

