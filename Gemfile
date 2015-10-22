source 'https://rubygems.org'
require 'resque/server'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
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

# Slim
gem 'slim'
gem 'slim-rails'

# For parsing
gem 'nokogiri'

#For creating works
gem "resque"

#For searching in server_side
gem 'elasticsearch-model'
gem 'elasticsearch-rails'


group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'rvm1-capistrano3', require: false
  gem 'capistrano-rails-console'

  # gem 'capistrano-bundler'
  # gem 'capistrano3-nginx_unicorn', git: 'git@github.com:revis0r/capistrano3-nginx_unicorn.git'
end



group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'


  gem 'rspec-rails'
  gem 'factory_girl_rails'
  # gem 'database_cleaner' #чистит тестувую базу
  # gem 'capybara'

  #Generate humanize random data
  gem 'forgery' 

  
  gem 'spork', git: 'git://github.com/manafire/spork.git', ref: '38c79dcedb246daacbadb9f18d09f50cc837de51'
  gem 'spork-rails', '~> 4.0.0'

  gem 'guard-rails'
  gem 'guard-rspec', '~> 4.5.0', require: false
  gem 'guard-livereload'
  gem 'guard-bundler'
  gem 'guard-spork'

end


