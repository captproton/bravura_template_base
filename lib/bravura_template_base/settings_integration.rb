# bravura_template_base/lib/bravura_template_base/settings_integration.rb
# lib/bravura_template_base/settings_integration.rb
require "active_support/concern"
require "bravura_template_base/null_settings"
require "bravura_template_base/guaranteed_setting_service"
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
        guaranteed_settings = BravuraTemplateBase::GuaranteedSettingService.for_account(current_account)
        {
          feature: OpenStruct.new(guaranteed_settings.get(:feature)),
          general: OpenStruct.new(guaranteed_settings.get(:general)),
          cta_button_setup: OpenStruct.new(guaranteed_settings.get(:cta_button_setup)),
          design: OpenStruct.new(guaranteed_settings.get(:design)),
          email_newsletter_setup: OpenStruct.new(guaranteed_settings.get(:email_newsletter_setup)),
          footer: OpenStruct.new(guaranteed_settings.get(:footer)),
          navigation: OpenStruct.new(guaranteed_settings.get(:navigation))
        }
      end
      OpenStruct.new(cached_settings)
    end
  end
end
