require 'bundler/setup'
Bundler.setup

require 'rails'
require 'active_support/all'
require 'action_controller'
require 'action_view'
require 'rspec/rails'
require 'factory_bot_rails'
require 'faker'
require 'ostruct'

require 'bravura_template_base'

ENV['RAILS_ENV'] = 'test'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Allow expectations on nil
  RSpec::Mocks.configuration.allow_message_expectations_on_nil = true

  # Print the 10 slowest examples and example groups at the end of the spec run
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option
  Kernel.srand config.seed
end

# Load factory definitions
require_relative 'factories/apps'

# Ensure FactoryBot is properly set up
# FactoryBot.find_definitions
