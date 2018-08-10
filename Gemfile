source 'https://rubygems.org'

gem 'pg'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
gem 'haml-rails'
gem 'simple_form'
gem 'cocoon'
gem 'rack-cors', :require => 'rack/cors'
gem 'whenever', :require => false
gem 'devise'

# Image upload to Amazon S3 Storage Cloud
gem 'paperclip'
gem 'aws-sdk', '~> 2.3'
gem "actionpack-page_caching"

gem 'puma'

group :development, :test do
  # Use sqlite3 as the database and keep the installation setup low
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'pry'
  gem 'whenever-test'
  gem 'timecop'
  gem 'rails-controller-testing', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'capistrano'
  gem 'capistrano-rails'
  gem "capistrano-db-tasks", require: false
  gem 'highline'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'seed_dump'
  gem 'rails-erd'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'cucumber-api-steps', require: false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
  #   end
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'capybara-screenshot'
  gem 'vcr'
  gem 'webmock'
end

