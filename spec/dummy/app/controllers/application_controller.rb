# spec/dummy/app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Mock the allow_browser method for testing
  def self.allow_browser(options = {})
    # This is a no-op method for testing purposes
  end

  # Call the method properly
  allow_browser versions: :modern
end
