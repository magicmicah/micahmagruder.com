module PostsHelper
  def rich_text_preview_words(post, word_limit = 20)
    doc = Nokogiri::HTML::DocumentFragment.parse(post.body.to_s)
    truncated = doc.text.split[0...word_limit].join(" ") + "..."
    doc.content = truncated
    doc.to_html.html_safe
  end
end
