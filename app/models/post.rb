class Post < ApplicationRecord
  after_validation :set_slug, only: [ :create, :update ]
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_rich_text :body
  scope :search, ->(query) {
    joins(:rich_text_body).where("action_text_rich_texts.body LIKE ? OR title LIKE ?", "%#{query}%", "%#{query}%")
  }
  scope :visible, -> { where(visible: true) }

  validates :title, presence: true, length: { maximum: 250 }
  validates :preview, presence: true, length: { maximum: 1000 }
  validates :published_on, presence: true


  # Virtual attribute for tags
  attr_accessor :tag_names

  # Callback to process tag names
  after_save :assign_tags

  def add_tags(tag_names)
    tag_names.each do |name|
      tag = Tag.find_or_create_by(name: name.strip.downcase)
      tags << tag unless tags.include?(tag)
    end
  end

  def to_param
    "#{id}-#{slug}"
  end

  private

  def assign_tags
    return unless tag_names

    self.tags = tag_names.split(",").map do |name|
      Tag.find_or_create_by(name: name.strip.downcase)
    end
  end

  def set_slug
    self.slug = title.to_s.parameterize
  end
end
