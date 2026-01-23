require "open-uri"

class GoodreadsService
  GOODREADS_USER_ID = "956835"
  BASE_RSS_URL = "https://www.goodreads.com/review/list_rss/#{GOODREADS_USER_ID}"
  CACHE_TTL = 1.hour

  def self.currently_reading
    fetch_shelf("currently-reading")
  end

  def self.recently_read(limit: 5)
    fetch_shelf("read").first(limit)
  end

  private

  def self.fetch_shelf(shelf)
    cache_key = "goodreads_#{shelf}"
    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL) do
      fetch_books(shelf)
    end
  rescue => e
    Rails.logger.error("GoodreadsService error: #{e.message}")
    []
  end

  def self.fetch_books(shelf)
    url = "#{BASE_RSS_URL}?shelf=#{shelf}"
    response = URI.open(url, "User-Agent" => "Ruby/Feedjira").read
    feed = Feedjira.parse(response)

    feed.entries.map do |entry|
      {
        title: entry.title,
        author: extract_author(entry),
        cover_url: extract_cover_url(entry),
        goodreads_url: entry.url,
        rating: extract_rating(entry),
        review: extract_review(entry)
      }
    end
  rescue => e
    Rails.logger.error("Failed to fetch Goodreads RSS: #{e.message}")
    []
  end

  def self.extract_author(entry)
    # Author is in the description HTML
    if entry.summary =~ /author:\s*([^<]+)/i
      $1.strip
    else
      "Unknown Author"
    end
  end

  def self.extract_cover_url(entry)
    # Cover image URL is in the description HTML
    if entry.summary =~ /<img[^>]+src="([^"]+)"/i
      upscale_cover_url($1)
    else
      nil
    end
  end

  def self.upscale_cover_url(url)
    # Goodreads uses _SX50_, _SY75_, etc. for sizing
    # Replace with _SY400_ for higher resolution
    url.gsub(/\._S[XY]\d+_\./, "._SY400_.")
  end

  def self.extract_rating(entry)
    # Match user's rating, not "average rating"
    if entry.summary =~ /<br\/?>\s*rating: (\d+)/i
      $1.to_i
    else
      nil
    end
  end

  def self.extract_review(entry)
    if entry.summary =~ /review: <br\/?>(.+?)(<br\/?>\s*<br\/?>|$)/mi
      review = $1.strip.gsub(/<br\/?>/, " ").strip
      review.empty? ? nil : review
    else
      nil
    end
  end
end
