class Book < ApplicationRecord
  belongs_to :category

  has_many :borrowings, dependent: :restrict_with_error
  has_many :users, through: :borrowings

  scope :search, lambda { |query|
    return all if query.blank?

    token = "%#{query.strip}%"
    where("title ILIKE :q OR author ILIKE :q OR isbn ILIKE :q", q: token)
  }

  validates :title, :author, :isbn, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies, :available_copies,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :available_not_more_than_total

  def available?
    available_copies.positive?
  end

  private

  def available_not_more_than_total
    return if available_copies.blank? || total_copies.blank?
    return if available_copies <= total_copies

    errors.add(:available_copies, "must be less than or equal to total copies")
  end
end

