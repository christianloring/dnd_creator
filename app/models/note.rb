class Note < ApplicationRecord
  belongs_to :user
  belongs_to :notable, polymorphic: true

  validates :title, :body, presence: true
end
