class Link < ApplicationRecord
  has_many :link_tags, dependent: :destroy
  has_many :tags, through: :link_tags

  validates :title, presence: true, length: { maximum: 500 }
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }

  # Virtual attribute for tags (following Post pattern)
  attr_accessor :tag_names

  # Callback to process tag names and add domain tag
  after_create :add_domain_tag
  after_save :assign_tags

  scope :recent, -> { order(bookmarked_at: :desc) }
  scope :search, ->(query) {
    if query.downcase.start_with?("tag:")
      tag_name = query[4..].strip.downcase
      joins(:tags).where("tags.name ILIKE ?", tag_name).distinct
    else
      left_joins(:tags)
        .where("links.title ILIKE :q OR links.url ILIKE :q OR links.comment ILIKE :q OR tags.name ILIKE :q", q: "%#{query}%")
        .distinct
    end
  }

  def add_tags(tag_names)
    tag_names.each do |name|
      tag = Tag.find_or_create_by(name: name.strip.downcase)
      tags << tag unless tags.include?(tag)
    end
  end

  # Media detection methods
  def youtube?
    url.match?(/(?:youtube\.com|youtu\.be)/)
  end

  def twitter?
    url.match?(/twitter\.com\/|x\.com\//)
  end

  def youtube_video_id
    return nil unless youtube?

    patterns = [
      /youtube\.com\/watch\?v=([^&\?\/]+)/,      # standard watch URL
      /youtube\.com\/embed\/([^&\?\/]+)/,         # embed URL
      /youtube\.com\/v\/([^&\?\/]+)/,             # old embed URL
      /youtube\.com\/shorts\/([^&\?\/]+)/,        # shorts
      /youtu\.be\/([^&\?\/]+)/                    # short URL
    ]

    patterns.each do |pattern|
      match = url.match(pattern)
      return match[1] if match
    end

    nil
  end

  def domain
    URI.parse(url).host&.sub(/^www\./, "")
  rescue URI::InvalidURIError
    nil
  end

  private

  def assign_tags
    return unless tag_names

    # Add user-provided tags
    tag_names.split(",").each do |name|
      tag = Tag.find_or_create_by(name: name.strip.downcase)
      tags << tag unless tags.include?(tag)
    end
  end

  def add_domain_tag
    return unless domain.present?

    domain_tag = Tag.find_or_create_by(name: domain.downcase)
    tags << domain_tag unless tags.include?(domain_tag)
  end
end
