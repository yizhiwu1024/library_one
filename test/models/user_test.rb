require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "member cannot borrow more than five active books" do
    user = users(:member)
    book = books(:ruby_book)

    4.times do |index|
      Borrowing.create!(
        user: user,
        book: book,
        borrowed_on: Date.current - (index + 1).days,
        due_on: Date.current + 10.days,
        status: "borrowed",
        renewal_count: 0
      )
    end

    assert_not user.can_borrow_more?
  end
end

