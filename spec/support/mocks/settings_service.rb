# spec/support/mocks/settings_service.rb

class MockSettingsService
  def self.for_account(account)
    new
  end

  def [](key)
    # Return a mock object that responds to any method
    OpenStruct.new
  end
end

# Mocking the Settings::Feature or any other constant that might be referenced
module Settings
  Feature = OpenStruct.new(
    some_setting: 'default_value' # Replace with expected mock settings
  )
end

# Mocking the Settings::General constant
module Settings
  General = OpenStruct.new(
    # Add mock settings here
  )
end

# Mocking the Settings::CtaButtonSetup constant
module Settings
  CtaButtonSetup = OpenStruct.new(
    # Add mock settings here
  )
end

# Mocking the Settings::EmailNewsletterSetup constant
module Settings
  EmailNewsletterSetup = OpenStruct.new(
    # Add mock settings here
  )
end

# Mocking the Settings::Footer constant
module Settings
  Footer = OpenStruct.new(
    # Add mock settings here
  )
end

# Mocking the Settings::Navigation constant
module Settings
  Navigation = OpenStruct.new(
    # Add mock settings here
  )
end
