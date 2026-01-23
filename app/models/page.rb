class Page < ApplicationRecord
  has_rich_text :content

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }

  scope :in_nav, -> { where(show_in_nav: true).order(:title) }

  before_validation :normalize_slug

  private

  def normalize_slug
    self.slug = slug.to_s.downcase.strip
  end
end
