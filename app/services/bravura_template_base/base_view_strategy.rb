# app/services/bravura_template_base/base_view_strategy.rb
module BravuraTemplateBase
  class BaseViewStrategy
    def initialize(settings, options = {})
      @settings = settings
      @options = options
    end

    def template_for(action)
      template_name = @settings.get("design.template")
      "bravura_template_#{template_name}/#{action}"
    end

    def layout
      template_name = @settings.get("design.template")
      "bravura_template_#{template_name}/application"
    end

    # Other common methods...
  end
end
