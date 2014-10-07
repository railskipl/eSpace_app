
#For Local machine keys
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :facebook, '167009010123257', 'c299160fa9e8798802bb88fb7023a644'
  
end

