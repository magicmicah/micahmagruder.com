require 'faker'

Post.destroy_all
Tag.destroy_all


40.times do
  jack_handey = Faker::Quote.jack_handey

  # get random color
  color1 = Faker::Color.color_name
  color2 = Faker::Color.color_name
  post = Post.create!(
    title: Faker::Book.title,
    preview: jack_handey,
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
