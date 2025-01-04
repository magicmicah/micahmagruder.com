class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  # Ensure tag names are unique and case-insensitive
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
