

# # #For Local machine keys
if Rails.env.development?
	OmniAuth.config.logger = Rails.logger

	Rails.application.config.middleware.use OmniAuth::Builder do
	  
	  provider :facebook, '382895341863463', '70e00b19e5cf11f56990e9402da7e8f5',scope: "user_friends, read_friendlists"
	  
	end
else	

# For heroku server keys
	OmniAuth.config.logger = Rails.logger
	OmniAuth.config.full_host = "http://store-finding-system.herokuapp.com"
	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :facebook, "463439180461791", "da2a8a7e85b8c3eda15f129204dd9d23",scope: "user_friends, read_friendlists"
	end
end




