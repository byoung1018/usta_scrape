source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'annotate'
gem 'rails'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'nokogiri'
gem 'anemone'
gem 'byebug'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-awesome_print', require: false # use awesome_print without .pryrc
  gem 'pry-coolline', require: false      # syntax highlighting
  gem 'pry-byebug', require: true        # debugger (itself buggy; breakpoints not reliable)
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


