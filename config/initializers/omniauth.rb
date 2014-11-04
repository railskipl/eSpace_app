

# #For Local machine keys
# OmniAuth.config.logger = Rails.logger

# Rails.application.config.middleware.use OmniAuth::Builder do
  
#   provider :facebook, '382895341863463', '70e00b19e5cf11f56990e9402da7e8f5'
  
# end

# For heroku server keys
OmniAuth.config.logger = Rails.logger
OmniAuth.config.full_host = "http://store-finding-system.herokuapp.com"
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "717648718312199", "50e27447366c3566a33f6d7832c0b418"
end





