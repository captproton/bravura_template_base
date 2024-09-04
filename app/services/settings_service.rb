# app/services/settings_service.rb

class SettingsService
  @settings = {}

  SETTING_MODELS = [
    Settings::Feature,
    Settings::General,
    Settings::CtaButtonSetup,
    Settings::Design,
    Settings::EmailNewsletterSetup,
    Settings::Footer,
    Settings::Navigation
  ]

  class << self
    def for_account(account)
      raise ArgumentError, "Account cannot be nil" if account.nil?

      @settings[account.id] ||= SETTING_MODELS.each_with_object({}) do |model, settings|
        key = model.name.demodulize.underscore.to_sym
        settings[key] = model.find_by(account: account)
      end
    end

    def clear_cache
      @settings = {}
    end

    def clear_cache_for_account(account)
      @settings.delete(account.id)
    end
  end
end
