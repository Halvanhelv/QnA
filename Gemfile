# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 8.1.3'

# Core
gem 'bootsnap', require: false
# json 3.x breaks ActiveSupport::JSON.decode on Rails 8.1
gem 'json', '~> 3.0'
gem 'pg', '~> 1.5'
gem 'puma', '>= 6.0'
gem 'tzinfo-data', platforms: %i[windows jruby]

# Hotwire stack
gem 'importmap-rails'
gem 'propshaft'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'

# Solid stack (queue, cache, cable in the database)
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
gem 'mission_control-jobs'

# Deployment
gem 'kamal', require: false
gem 'thruster', require: false

# Views
gem 'slim-rails'
gem 'lexxy', '~> 0.9'
gem 'will_paginate'

# Active Storage variants
gem 'image_processing', '~> 1.2'

# Auth
gem 'cancancan'
gem 'devise'
gem 'doorkeeper'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-telegram'

# API
gem 'active_model_serializers'

# Search
gem 'pg_search'

# External services
gem 'google-cloud-storage', require: false
gem 'faraday-retry'
gem 'octokit'

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop-rails-omakase', require: false
end

group :development do
  gem 'letter_opener'
  # letter_opener needs kconv, which left the standard library in Ruby 3.4+
  gem 'nkf'
  gem 'web-console'
end

group :test do
  gem 'minitest-mock'
  gem 'capybara'
  gem 'selenium-webdriver'
end
