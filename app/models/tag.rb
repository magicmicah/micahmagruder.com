class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  has_many :link_tags, dependent: :destroy
  has_many :links, through: :link_tags

  # Ensure tag names are unique and case-insensitive
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
