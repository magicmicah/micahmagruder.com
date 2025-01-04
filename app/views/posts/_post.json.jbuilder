json.extract! post, :id, :title, :body, :visible, :published_on, :created_at, :updated_at, :post_tags
json.url post_url(post, format: :json)
