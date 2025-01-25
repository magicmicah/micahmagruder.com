require "net/http"

class ProxyController < ApplicationController
  def fetch_stream
    url = URI.parse(params[:url])
    response = Net::HTTP.get_response(url)
    render plain: response.body, content_type: response.content_type
  end
end
