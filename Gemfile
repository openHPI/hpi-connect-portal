source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.17.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.4.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0.2'

# Create filters easily with scopes
gem 'has_scope'

# Annotate database fields to model files
gem 'annotate', '>=2.6.1'

# Secure Password Hashes
gem 'bcrypt-ruby', '~> 3.1.5'

# Ruby linting
gem 'rubocop'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-mocks'
  gem 'rake'
  gem 'letter_opener'
  gem 'factory_girl_rails', require: false
  gem 'codeclimate-test-reporter', '~> 0.3.0', require: nil
  gem 'rails_log_stdout',           git: 'https://github.com/heroku/rails_log_stdout.git'
  gem 'rails3_serve_static_assets', git: 'https://github.com/heroku/rails3_serve_static_assets.git'
  gem 'byebug'
end

gem 'simplecov', group: :test, require: nil

# heroku specific stuff
gem 'rails_12factor', group: :production
gem 'newrelic_rpm', '~> 3.7.1.188', group: :production
gem 'airbrake', '~> 3.1.15'

# basic layouting
# gem 'twitter-bootstrap-rails'

# bootstrap 3
gem 'bootstrap-rails-engine'

# navigation
gem 'simple-navigation', '~> 3.11'

# open ID gem for user activation
gem 'ruby-openid'
gem 'open_id_authentication'

# authorizations in one place
gem 'cancan'

# simple http requests
gem 'rest-client'

# command line parsing for project registration
gem 'highline'

# for picture Upload
gem 'paperclip'

# for cron jobs
gem 'whenever'

# add some more UI controls
gem 'jquery-ui-rails'

# jquery plugin for rating stars
gem 'jquery-raty-rails', git: 'https://github.com/bmc/jquery-raty-rails.git'

# load jQuery fast without refresh
gem 'jquery-turbolinks'

# a Helper to validate dates
gem 'validates_timeliness', '~> 3.0'

# simplify rspec integration testing
gem 'capybara'

# factory girl for test factories
gem 'factory_girl'

# replacement for glyphicons
gem 'font-awesome-rails', '~> 4.0.3.1'

# pagination
gem 'will_paginate', '~> 3.0'

# styles pagination with bootstrap
gem 'will_paginate-bootstrap'

gem 'active_enum', git: 'https://github.com/adzap/active_enum.git'
gem 'jquery-star-rating-rails'
gem 'simple_form'

# WYSIWYG Text Editor
gem 'tinymce-rails', '~> 4.1.5'
gem 'tinymce-rails-langs', '~> 4.20140129'
gem 'sanitize', '~> 3.0.2'

# Birthdate validation
gem 'chronic', '~> 0.10.2'

group :test do
  gem 'email_spec'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end

# flags
gem 'famfamfam_flags_rails'

# saves config settings in a database
gem 'configurable_engine'

# asset handling for heroku
gem 'rails_serve_static_assets'

# xing
gem 'xing_api', '~> 0.1'

# deployment with nginx and unicorn
gem 'unicorn'
gem 'capistrano', '~> 3.6'
gem 'capistrano-rails', '~> 1.2'
gem 'capistrano-bundler'
gem 'capistrano-rvm'
