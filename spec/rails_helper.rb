# spec/rails_helper.rb or spec/spec_helper.rb

# Comment out or remove lines that load the full Rails environment
# ENV['RAILS_ENV'] ||= 'test'
# require File.expand_path('../dummy/config/environment', __FILE__)

require 'bundler/setup'
Bundler.require(:default, :development)

require 'rspec/rails'
require 'factory_bot_rails'
require 'bravura_template_base'

RSpec.configure do |config|
  config.use_transactional_fixtures = false # We're not using a database
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
