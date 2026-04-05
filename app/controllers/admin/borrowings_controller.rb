module Admin
  class BorrowingsController < BaseController
    before_action :set_borrowing, only: %i[show edit update]

    def index
      @borrowings = Borrowing.includes(:user, :book).order(created_at: :desc)
    end

    def show; end

    def edit; end

    def update
      old_status = @borrowing.status

      Borrowing.transaction do
        @borrowing.assign_attributes(admin_borrowing_params)
        sync_inventory_for_status_change(old_status)
        @borrowing.save!
      end

      redirect_to admin_borrowing_path(@borrowing), notice: "Borrowing updated successfully."
    rescue ActiveRecord::RecordInvalid
      render :edit, status: :unprocessable_entity
    end

    private

    def set_borrowing
      @borrowing = Borrowing.find(params[:id])
    end

    def admin_borrowing_params
      params.require(:borrowing).permit(:status, :borrowed_on, :due_on, :returned_on)
    end

    def sync_inventory_for_status_change(old_status)
      return if old_status == @borrowing.status

      @borrowing.book.with_lock do
        if old_status.in?(%w[borrowed overdue]) && @borrowing.returned?
          if @borrowing.book.available_copies >= @borrowing.book.total_copies
            @borrowing.errors.add(:status, "cannot be changed because stock is already full")
            raise ActiveRecord::RecordInvalid, @borrowing
          end
          @borrowing.book.increment!(:available_copies)
          @borrowing.returned_on ||= Date.current
        elsif old_status == "returned" && @borrowing.status.in?(%w[borrowed overdue])
          if @borrowing.book.available_copies <= 0
            @borrowing.errors.add(:status, "cannot be changed because stock is unavailable")
            raise ActiveRecord::RecordInvalid, @borrowing
          end
          @borrowing.book.decrement!(:available_copies)
          @borrowing.returned_on = nil
        end
      end
    end
  end
end



