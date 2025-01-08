module PostsHelper
  def wrap_pre_tags(content)
    content.gsub(/<pre>(.*?)<\/pre>/m) do
      <<-HTML
      <div class="code-block">
        <pre>#{$1}</pre>
        <button class="copy-button">Copy</button>
      </div>
      HTML
    end.html_safe
  end
end
