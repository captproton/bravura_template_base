source "https://rubygems.org"

# Specify your gem's dependencies in bravura_template_base.gemspec.
gemspec

gem "puma"
gem "sqlite3", "~> 1.4"
gem "sprockets-rails"

# Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
gem "rubocop-rails-omakase", require: false

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :development, :test do
  gem "rspec-rails", "~> 6.1", ">= 6.1.3"
  gem "factory_bot_rails", "~> 6.4", ">= 6.4.3"
  gem "faker", " ~> 3.4", ">= 3.4.1"
  gem "pry-byebug"

  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
end

# Add any additional gems your engine needs here
# For example:
# gem 'devise'
# gem 'cancancan'
# gem 'paper_trail'

# Gems for asset pipeline
gem "sass-rails"
gem "uglifier"

# Gems for JSON API
gem "jbuilder"

# Gems for background jobs
# gem 'sidekiq'

# Gems for caching
# gem 'redis'

# Gems for full-text search
# gem 'elasticsearch-model'
# gem 'elasticsearch-rails'

# Uncomment the following line if you want to use webpacker
# gem 'webpacker', '~> 5.0'
