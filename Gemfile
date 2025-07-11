# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', '~> 7.2', '>= 7.2.2.1'
gem 'rails', '~> 7.2', '>= 7.2.2.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'sprockets'
gem 'webpacker'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'cocoon'
gem 'gon'
gem 'handlebars-source'
gem 'jbuilder'

gem 'octicons'
gem 'octicons_helper'
gem 'octokit'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-telegram'

gem 'active_model_serializers'
gem 'cancancan'
gem 'capybara-email'
gem 'database_cleaner'
gem 'doorkeeper'
gem 'faraday-retry'
gem 'mini_racer'
gem 'mysql2'
gem 'oj'
gem 'redis'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim-rails'
gem 'thinking-sphinx'
gem 'unicorn'
gem 'whenever', require: false
gem 'will_paginate'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# Auth
gem 'devise'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
gem 'decent_exposure'
gem 'google-cloud-storage', require: false
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'localtunnel'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'capistrano', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'letter_opener'
  gem 'rubocop-rails'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'webdrivers'
end

# Windows does not include zoneinfo attachment, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
