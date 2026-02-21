require 'faker'

Post.destroy_all
Tag.destroy_all
Link.destroy_all
User.destroy_all

# Create a default user with API token
user = User.create!(
  email_address: 'test@test.com',
  password: 'password',
)
user.generate_api_token!


40.times do
  jack_handey = Faker::Quote.jack_handey

  # get random color
  color1 = Faker::Color.color_name
  color2 = Faker::Color.color_name
  post = Post.create!(
    title: Faker::Book.title,
    published_on: Faker::Date.backward(days: 60),
    visible: rand < 0.67, # We only want 2/3 of the pages to be disible.
    tag_names: "#{color1}, #{color2}"
  )

  rich_content = <<~HTML
    <p><strong>#{jack_handey}</strong></p>
    <p>#{Faker::Lorem.paragraphs(number: 2).join("</p><p>")}</p>
    <ul>
      <li>#{Faker::Lorem.sentence}</li>
      <li>#{Faker::Lorem.sentence}</li>
      <li>#{Faker::Lorem.sentence}</li>
    </ul>
    <blockquote>#{Faker::Quote.matz}</blockquote>
  HTML

  post.body = rich_content
  post.save
end

puts "40 development posts created!"

# Create sample links
sample_links = [
  {
    title: "Ruby on Rails Guides",
    url: "https://guides.rubyonrails.org/",
    comment: "Official Rails documentation - always useful",
    tags: "ruby, rails, documentation"
  },
  {
    title: "Understanding the YouTube Algorithm - Veritasium",
    url: "https://www.youtube.com/watch?v=fHsa9DqmId8",
    comment: "Great video explaining how content discovery works on YouTube",
    tags: "youtube, tech, algorithms"
  },
  {
    title: "DHH on Twitter",
    url: "https://twitter.com/dhh/status/1234567890",
    comment: "Interesting thread about Rails development philosophy",
    tags: "twitter, rails, dhh"
  },
  {
    title: "Hacker News",
    url: "https://news.ycombinator.com/",
    comment: "Daily reading for tech news and discussions",
    tags: "news, tech, reading"
  },
  {
    title: "CSS Tricks - A Complete Guide to Flexbox",
    url: "https://css-tricks.com/snippets/css/a-guide-to-flexbox/",
    comment: "Best flexbox reference on the web - I keep coming back to this",
    tags: "css, frontend, reference"
  },
  {
    title: "The Pragmatic Programmer",
    url: "https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/",
    comment: "Classic book every developer should read",
    tags: "books, programming, career"
  },
  {
    title: "Learn Vim Progressively",
    url: "https://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/",
    comment: "The best guide for learning Vim step by step",
    tags: "vim, tools, productivity"
  },
  {
    title: "Designing Data-Intensive Applications",
    url: "https://dataintensive.net/",
    comment: "Incredible book on distributed systems and databases",
    tags: "books, databases, architecture"
  },
  {
    title: "Tom Scott - Why the US Military Cared About a 1tried",
    url: "https://www.youtube.com/watch?v=y2TKzY4gLSo",
    comment: "Fascinating history of the F-35 and software complexity",
    tags: "youtube, history, software"
  },
  {
    title: "GitHub - htmx",
    url: "https://github.com/bigskysoftware/htmx",
    comment: "HTMX lets you build modern user interfaces with simple HTML attributes",
    tags: "htmx, frontend, javascript"
  }
]

sample_links.each_with_index do |link_data, index|
  link = Link.create!(
    title: link_data[:title],
    url: link_data[:url],
    comment: link_data[:comment],
    bookmarked_at: (index + 1).days.ago
  )
  link.add_tags(link_data[:tags].split(", "))
end

puts "#{sample_links.count} development links created!"
puts ""
puts "Test user credentials:"
puts "  Email: test@test.com"
puts "  Password: password"
puts "  API Token: #{user.api_token}"
