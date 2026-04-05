class User < ApplicationRecord
  has_secure_password

  enum :role, { member: "member", admin: "admin" }, validate: true
  enum :status, { active: "active", suspended: "suspended" }, validate: true

  has_one :user_profile, dependent: :destroy
  has_many :borrowings, dependent: :destroy
  has_many :books, through: :borrowings

  accepts_nested_attributes_for :user_profile

  before_validation :normalize_email
  after_create :ensure_profile

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  def active_borrowings
    borrowings.active
  end

  def can_borrow_more?
    active_borrowings.count < Borrowing::MAX_ACTIVE_BORROWINGS
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def ensure_profile
    create_user_profile!(full_name: email.split("@").first.titleize) unless user_profile
  end
end


