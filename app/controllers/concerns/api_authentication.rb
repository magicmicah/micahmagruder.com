module ApiAuthentication
  extend ActiveSupport::Concern

  # Public method for use in callback conditions
  def api_request?
    request.format.json? && extract_bearer_token.present?
  end

  private

  def authenticate_api_token!
    token = extract_bearer_token
    @api_user = User.find_by_api_token(token)

    unless @api_user
      render json: { error: "Invalid or missing API token" }, status: :unauthorized
    end
  end

  def extract_bearer_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.start_with?("Bearer ")
    auth_header.split(" ").last
  end
end
