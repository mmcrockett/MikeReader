source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/mmcrockett/MikeReader.git" }

ruby '2.7.8'

gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'mysql2', '>= 0.5'
gem 'webpacker', '~> 4.0'
gem 'jbuilder', '~> 2.7'
gem 'httparty'

gem "puma", "~> 4.3"

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'httparty_with_cookies'
  gem 'capistrano', '~> 3.14', require: false
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'fakeweb'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
