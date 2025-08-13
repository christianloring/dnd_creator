class Encounter < ApplicationRecord
  belongs_to :user

  validates :inputs, presence: true
  validates :composition, presence: true
  validates :total_xp, presence: true, numericality: { greater_than: 0 }
  validates :slug, uniqueness: true, allow_blank: true

  before_create :generate_slug, if: -> { slug.blank? }

  private

  def generate_slug
    self.slug = SecureRandom.urlsafe_base64(8)
  end
end
