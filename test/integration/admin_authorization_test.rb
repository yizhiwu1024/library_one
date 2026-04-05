require "test_helper"

class AdminAuthorizationTest < ActionDispatch::IntegrationTest
  test "member cannot access admin pages" do
    sign_in_as(users(:member))

    get admin_root_path
    assert_redirected_to root_path
  end

  test "admin can access dashboard" do
    sign_in_as(users(:admin))

    get admin_root_path
    assert_response :success
  end

  test "admin marking borrowing as returned increases available copies" do
    sign_in_as(users(:admin))

    borrowing = borrowings(:active_borrowing)
    book = borrowing.book
    previous_available = book.available_copies

    patch admin_borrowing_path(borrowing), params: {
      borrowing: {
        status: "returned",
        borrowed_on: borrowing.borrowed_on,
        due_on: borrowing.due_on,
        returned_on: Date.current
      }
    }

    assert_redirected_to admin_borrowing_path(borrowing)
    borrowing.reload
    book.reload

    assert borrowing.returned?
    assert_equal previous_available + 1, book.available_copies
  end
end


