# lib/bravura_template_base/settings_integration.rb

module BravuraTemplateBase
  module SettingsIntegration
    extend ActiveSupport::Concern

    def all_settings
      @all_settings ||= fetch_settings
    end

    def get_setting(key)
      keys = key.to_s.split(".")
      keys.inject(all_settings) do |settings, key|
        return nil unless settings.is_a?(Hash)
        settings[key.to_sym] || settings[key.to_s]
      end
    end

    def invalidate_settings_cache
      Rails.cache.delete("account_settings_#{current_account.id}") if Rails.cache
      SettingsService.clear_cache_for_account(current_account)
      @all_settings = nil
    end

    private

    def fetch_settings
      if Rails.cache
        Rails.cache.fetch("account_settings_#{current_account.id}", expires_in: 1.hour) do
          SettingsService.for_account(current_account)
        end
      else
        SettingsService.for_account(current_account)
      end
    end
  end
end
