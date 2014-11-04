
# #For Local machine keys
# OmniAuth.config.logger = Rails.logger

# Rails.application.config.middleware.use OmniAuth::Builder do
  
#   provider :facebook, '167009010123257', 'c299160fa9e8798802bb88fb7023a644'
  
# end


# # For heroku server keys
# OmniAuth.config.logger = Rails.logger
# OmniAuth.config.full_host = "http://store-finding-system.herokuapp.com"
# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :facebook, "717648718312199", "50e27447366c3566a33f6d7832c0b418"
# end

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '167009010123257', 'c299160fa9e8798802bb88fb7023a644'
end

