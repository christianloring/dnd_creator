class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
