json.extract! link, :id, :title, :url, :comment, :bookmarked_at, :created_at, :updated_at
json.tags link.tags.map(&:name)
json.domain link.domain
json.link_url link_url(link, format: :json)
