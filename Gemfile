source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/mmcrockett/MikeReader.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'sqlite3', '~> 1.4'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'httparty'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'httparty_with_cookies'
  gem 'puma'
  gem 'capistrano', '~> 3.14', require: false
  gem 'capistrano-sqlite-reuse', '>= 1.0.0'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
end

group :test do
  gem 'fakeweb'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
