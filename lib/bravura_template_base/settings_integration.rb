# lib/bravura_template_base/settings_integration.rb
require "active_support/concern"
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
      Rails.logger.debug "Getting setting for key: #{key}"
      result = guaranteed_setting_service.get(key)
      Rails.logger.debug "Final result: #{result.inspect}"
      result
    end

    def invalidate_settings_cache
      self.class.cache_store.delete("account_settings_#{current_account.id}")
      @all_settings = nil
      @guaranteed_setting_service = nil
    end

    private

    def fetch_settings
      self.class.cache_store.fetch("account_settings_#{current_account.id}", expires_in: 1.hour) do
        service = guaranteed_setting_service
        {
          feature: service.get(:feature),
          general: service.get(:general),
          cta_button_setup: service.get(:cta_button_setup),
          design: service.get(:design),
          email_newsletter_setup: service.get(:email_newsletter_setup),
          footer: service.get(:footer),
          navigation: service.get(:navigation)
        }
      end
    end

    def guaranteed_setting_service
      @guaranteed_setting_service ||= BravuraTemplateBase::GuaranteedSettingService.for_account(current_account)
    end
  end
end
