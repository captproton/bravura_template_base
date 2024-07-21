# lib/bravura_template_base/settings_integration.rb
require "active_support/concern"
require "bravura_template_base/null_settings"
require "ostruct"

module BravuraTemplateBase
  module SettingsIntegration
    extend ActiveSupport::Concern

    included do
      helper_method :all_settings, :get_setting
    end

    class_methods do
      def cache_store
        @cache_store ||= ActiveSupport::Cache::MemoryStore.new
      end

      def cache_store=(store)
        @cache_store = store
      end
    end

    def all_settings
      @all_settings ||= fetch_settings
    end

    def get_setting(key)
      keys = key.to_s.split(".")
      result = keys.inject(all_settings) do |settings, key|
        settings.respond_to?(:[]) ? settings[key.to_sym] : settings.send(key.to_sym)
      end
      result.is_a?(BravuraTemplateBase::NullSettings::NullBase) ? result.send(keys.last) : result
    end

    def invalidate_settings_cache
      self.class.cache_store.delete("account_settings_#{current_account.id}")
      SettingsService.clear_cache_for_account(current_account)
      @all_settings = nil
    end

    private

    def fetch_settings
      cached_settings = self.class.cache_store.fetch("account_settings_#{current_account.id}", expires_in: 1.hour) do
        SettingsService.for_account(current_account).transform_values(&:to_h)
      end

      {
        feature: cached_settings[:feature] ? OpenStruct.new(cached_settings[:feature]) : NullSettings::NullFeature.new,
        general: cached_settings[:general] ? OpenStruct.new(cached_settings[:general]) : NullSettings::NullGeneral.new,
        cta_button_setup: cached_settings[:cta_button_setup] ? OpenStruct.new(cached_settings[:cta_button_setup]) : NullSettings::NullCtaButtonSetup.new,
        design: cached_settings[:design] ? OpenStruct.new(cached_settings[:design]) : NullSettings::NullDesign.new,
        email_newsletter_setup: cached_settings[:email_newsletter_setup] ? OpenStruct.new(cached_settings[:email_newsletter_setup]) : NullSettings::NullEmailNewsletterSetup.new,
        footer: cached_settings[:footer] ? OpenStruct.new(cached_settings[:footer]) : NullSettings::NullFooter.new,
        navigation: cached_settings[:navigation] ? OpenStruct.new(cached_settings[:navigation]) : NullSettings::NullNavigation.new
      }
    end
  end
end
