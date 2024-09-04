# lib/bravura_template_base/setting_retriever.rb

module BravuraTemplateBase
  class SettingRetriever
    def initialize(settings, default_settings, fallback_value)
      @settings = settings
      @default_settings = default_settings
      @fallback_value = fallback_value
    end

    def get(key)
      category, setting = key.to_s.split(".")
      return @fallback_value if category.nil? || setting.nil?

      value = value_from_settings(category, setting)
      value = value_from_defaults(category, setting) if value.nil?

      if is_active_storage_attachment?(value)
        value.attached? ? value : default_image_for(category, setting)
      else
        value.nil? ? @fallback_value : value
      end
    end

    private

    def value_from_settings(category, setting)
      @settings[category.to_sym]&.send(setting.to_sym)
    end

    def value_from_defaults(category, setting)
      @default_settings.get("#{category}.#{setting}")
    end

    def is_active_storage_attachment?(value)
      defined?(ActiveStorage) && value.respond_to?(:attached?)
    end

    def default_image_for(category, setting)
      @default_settings.default_image_path(category, setting)
    end
  end
end
