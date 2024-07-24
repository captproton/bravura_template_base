# bravura_template_base/lib/bravura_template_base/settings_integration.rb
# lib/bravura_template_base/settings_integration.rb
require "active_support/concern"
require "bravura_template_base/null_settings"
require "ostruct"

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
        value = settings.respond_to?(:[]) ? settings[key.to_sym] : settings.send(key.to_sym)
        break GuaranteedSettingService::DefaultSetting.new(keys.first.to_sym) if value.nil?
        value
      end
      result.is_a?(GuaranteedSettingService::DefaultSetting) ? result.send(keys.last) : result
    end

    def invalidate_settings_cache
      self.class.cache_store.delete("account_settings_#{current_account.id}")
      SettingsService.clear_cache_for_account(current_account)
      @all_settings = nil
    end

    private

    def fetch_settings
      cached_settings = self.class.cache_store.fetch("account_settings_#{current_account.id}", expires_in: 1.hour) do
        guaranteed_settings = GuaranteedSettingService.for_account(current_account)
        {
          feature: guaranteed_settings.get(:feature),
          general: guaranteed_settings.get(:general),
          cta_button_setup: guaranteed_settings.get(:cta_button_setup),
          design: guaranteed_settings.get(:design),
          email_newsletter_setup: guaranteed_settings.get(:email_newsletter_setup),
          footer: guaranteed_settings.get(:footer),
          navigation: guaranteed_settings.get(:navigation)
        }
      end

      cached_settings.transform_values { |v| v.is_a?(Hash) ? OpenStruct.new(v) : v }
    end
  end
end
