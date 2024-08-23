# spec/rails_helper.rb
require 'spec_helper'
require 'rails-controller-testing'

ENV['RAILS_ENV'] ||= 'test'

# Require the dummy application's environment
require File.expand_path('../dummy/config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'factory_bot_rails'
require 'faker'
require 'shoulda-matchers'
require 'ostruct'

# Require the engine
require 'bravura_template_base'

# Load stub classes
require_relative 'support/stub_classes'
require 'support/stubs/bravura_template_prime/view_strategy'
require 'support/stubs/bravura_template_base/view_strategy_factory'

# Require support files
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # We're not using a database, so you might want to keep this false
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  # Include the mock NewsletterHelper in controller specs
  config.include NewsletterHelper, type: :controller
end

# Configure Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Load factory definitions
Dir[File.expand_path('factories/**/*.rb', __dir__)].sort.each { |f| require f }
