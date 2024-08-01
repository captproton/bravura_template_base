# lib/bravura_template_base/settings_integration.rb
require "active_support/concern"
require "bravura_template_base/null_settings"
require "bravura_template_base/guaranteed_setting_service"

module BravuraTemplateBase
  module SettingsIntegration
    extend ActiveSupport::Concern

    included do
      if respond_to?(:helper_method)
        helper_method :all_settings, :get_setting
      end
    end

    def all_settings
      @all_settings ||= fetch_settings
    end

    def get_setting(key)
      keys = key.to_s.split(".")
      result = keys.inject(all_settings) do |settings, key|
        break nil if settings.nil?
        settings.is_a?(OpenStruct) ? settings[key.to_sym] : settings[key.to_sym]
      end
      result.nil? ? GuaranteedSettingService::DefaultSetting.new(keys.first.to_sym).send(keys.last) : result
    end
    def invalidate_settings_cache
      self.class.cache_store.delete("account_settings_#{current_account.id}")
      ::SettingsService.clear_cache_for_account(current_account) if defined?(::SettingsService)
      @all_settings = nil
    end

    private

    def fetch_settings
      cached_settings = self.class.cache_store.fetch("account_settings_#{current_account.id}", expires_in: 1.hour) do
        settings_service = BravuraTemplateBase::GuaranteedSettingService.for_account(current_account)
        {
          feature: settings_service.get(:feature),
          general: settings_service.get(:general),
          cta_button_setup: settings_service.get(:cta_button_setup),
          design: settings_service.get(:design),
          email_newsletter_setup: settings_service.get(:email_newsletter_setup),
          footer: settings_service.get(:footer),
          navigation: settings_service.get(:navigation)
        }
      end
      cached_settings.transform_values { |v| v.is_a?(Hash) ? OpenStruct.new(v) : v }
    end
  end
end
