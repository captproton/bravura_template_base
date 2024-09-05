# lib/bravura_template_base/guaranteed_setting_service.rb

require_relative "setting_retriever"
require_relative "default_settings_repository"

module BravuraTemplateBase
  class GuaranteedSettingService
    def self.for_account(account)
      settings = SettingsService.for_account(account)
      new(settings, DefaultSettingsRepository.new)
    end

    def initialize(settings, default_settings, fallback_value = "N/A")
      @setting_retriever = SettingRetriever.new(settings, default_settings, fallback_value)
    end

    def get(key)
      @setting_retriever.get(key)
    end
  end
end
