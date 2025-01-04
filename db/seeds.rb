# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Load the shared seeds (optional, if you have shared logic)
load Rails.root.join('db/seeds/shared.rb') if File.exist?(Rails.root.join('db/seeds/shared.rb'))

# Load the environment-specific seeds
env_seed_file = Rails.root.join("db/seeds/#{Rails.env}.rb")
if File.exist?(env_seed_file)
  puts "Loading #{Rails.env} seeds..."
  load env_seed_file
else
  puts "No seeds file found for #{Rails.env} environment."
end
