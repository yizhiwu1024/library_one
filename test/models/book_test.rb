require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "available copies cannot exceed total copies" do
    book = books(:ruby_book)
    book.available_copies = book.total_copies + 1

    assert_not book.valid?
    assert_includes book.errors[:available_copies], "must be less than or equal to total copies"
  end
end

