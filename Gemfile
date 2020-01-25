source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 6.0.x'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'webpacker', github: "rails/webpacker"
gem 'jbuilder', '~> 2.7'
gem 'redis', '~> 4.0'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'textacular', '~> 5.0' # pg search
gem 'google-api-client' # google sheet
gem 'appsignal' # performance monitoring

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'letter_opener_web'
end

group :development do
  gem 'web-console', github: 'rails/web-console'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rack-livereload', group: :development
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'guard-minitest'
  gem 'rack-mini-profiler'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
