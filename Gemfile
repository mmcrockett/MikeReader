source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/mmcrockett/MikeReader.git" }

ruby '3.1.6'

gem 'rails', '~> 6'
gem 'mysql2', '>= 0.5'
gem 'webpacker', '~> 5.0'
gem 'jbuilder', '~> 2.11'
gem 'httparty'

gem "puma", "~> 5"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3', '~> 1.7'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'webdrivers'
  gem 'fakeweb'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "rss", "~> 0.3.1"
