source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'httparty'

group :test do
  gem 'fakeweb'
end

group :production do
  gem 'therubyracer', :platforms => :ruby
end

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'httparty_with_cookies'

  gem 'capistrano', '3.8.1'
  gem 'capistrano-secrets-generate', '>= 1.0.0'
  gem 'capistrano-sqlite-reuse', '>= 1.0.0'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'highline'
end
