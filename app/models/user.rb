class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def generate_api_token!
    update!(api_token: SecureRandom.hex(32))
  end

  def reset_api_token!
    generate_api_token!
  end

  def self.find_by_api_token(token)
    return nil if token.blank?
    find_by(api_token: token)
  end
end
