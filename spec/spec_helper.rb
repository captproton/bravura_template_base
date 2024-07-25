require 'bundler/setup'
Bundler.setup

# Set up Rails environment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../spec/dummy/config/environment', __dir__)

require 'rspec/rails'
require 'factory_bot_rails'
require 'faker'
require 'ostruct'

# Require the engine
require 'bravura_template_base'

# Load stub classes
require_relative 'support/stub_classes'

# Configure RSpec
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  RSpec::Mocks.configuration.allow_message_expectations_on_nil = true

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed

  # Clear and reload factories before the test suite runs
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

# Load factory definitions
Dir[File.expand_path('factories/**/*.rb', __dir__)].each { |f| require f }
