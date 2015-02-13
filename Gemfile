source 'https://rubygems.org'

ruby '2.1.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'

gem 'mysql2', group: :development
gem 'pg'
gem 'sidetiq'

gem 'devise'

gem 'bullet', group: :development
gem 'ransack'

gem 'puma'
gem 'foreman', require: false
# gem 'figaro'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer'
gem 'execjs'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'rack-mini-profiler'
# Social network Login
gem 'omniauth'
gem "omniauth-facebook"
gem 'oauth2'

gem 'bootstrap-sass'

gem 'stripe'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development

gem 'geocoder'
gem "koala", "~> 1.10.0rc"

gem 'wkhtmltopdf-binary'
gem 'wicked_pdf'
gem 'wkhtmltopdf-heroku'

# Paperclip gem for managing file uploads
gem 'paperclip', github: 'thoughtbot/paperclip'
gem 'aws-sdk', '~> 1.61'

gem 'will_paginate'
gem 'rest-client'

gem 'traceroute'

group :development do
  gem 'brakeman', :require => false
  gem 'letter_opener'
end


group :development, :test do
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'selenium-webdriver'
end

group :production do
  gem 'rails_12factor'
end
