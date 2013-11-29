source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.0'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0', platforms: :ruby 

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.5'

# Annotate database fields to model files
gem 'annotate', '>=2.5.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'rake'
  gem 'factory_girl_rails', :require => false
  #gem 'codeclimate-test-reporter', :require => nil
end

gem 'simplecov', :group => :test, :require => nil

# heroku specific stuff
gem 'rails_12factor', group: :production

# basic layouting
gem 'twitter-bootstrap-rails'

# navigation
gem 'simple-navigation', '~> 3.11'

# authentication including support for oauth
gem 'devise', '~> 3.1'
gem 'devise_openid_authenticatable'

# authorizations in one place
gem 'cancan'

# simple http requests
gem 'rest-client'

# command line parsing for project registration
gem 'highline'

#picture uploads
gem 'paperclip', :git => 'http://github.com/thoughtbot/paperclip.git'

# simplify rspec integration testing
gem 'capybara'
