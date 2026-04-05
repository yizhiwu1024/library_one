class Borrowing < ApplicationRecord
  BORROW_DAYS = 10
  MAX_RENEWALS = 1
  MAX_ACTIVE_BORROWINGS = 5

  belongs_to :user
  belongs_to :book

  enum :status, {
    borrowed: "borrowed",
    returned: "returned",
    overdue: "overdue"
  }, validate: true

  scope :active, -> { where(status: %w[borrowed overdue]) }

  before_validation :assign_defaults, on: :create

  validates :borrowed_on, :due_on, :status, :renewal_count, presence: true
  validates :renewal_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :due_on_not_before_borrowed_on

  def can_renew?
    active? && renewal_count < MAX_RENEWALS
  end

  def active?
    borrowed? || overdue?
  end

  def renew!
    return false unless can_renew?

    update(due_on: due_on + BORROW_DAYS.days, renewal_count: renewal_count + 1)
  end

  def return_book!
    return false unless active?

    transaction do
      book.with_lock do
        book.increment!(:available_copies)
      end
      update!(status: :returned, returned_on: Date.current)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def assign_defaults
    self.borrowed_on ||= Date.current
    self.due_on ||= borrowed_on + BORROW_DAYS.days
    self.status ||= "borrowed"
    self.renewal_count ||= 0
  end

  def due_on_not_before_borrowed_on
    return if due_on.blank? || borrowed_on.blank?
    return if due_on >= borrowed_on

    errors.add(:due_on, "must be on or after borrowed_on")
  end
end

