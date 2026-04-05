class UserProfile < ApplicationRecord
  belongs_to :user

  validates :full_name, presence: true, length: { maximum: 100 }
  validates :phone, length: { maximum: 30 }, allow_blank: true
end

