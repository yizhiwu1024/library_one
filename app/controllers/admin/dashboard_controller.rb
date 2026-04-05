module Admin
  class DashboardController < BaseController
    def show
      @active_borrowings_count = Borrowing.active.count
      @overdue_count = Borrowing.overdue.count
      @weekly_borrowings_count = Borrowing.where("borrowed_on >= ?", Date.current.beginning_of_week).count
    end
  end
end

