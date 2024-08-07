module BravuraTemplateBase
  class ViewStrategyFactory
    def self.create(settings, options = {})
      # template_name = settings.get("design.template")
      # FIXME: templagte name is static
      template_name = "prime"
      strategy_class = strategy_class_for(template_name)
      strategy_class.new(settings, options)
    end

    private

    def self.strategy_class_for(template_name)
      case template_name.to_sym
      when :prime
        BravuraTemplatePrime::ViewStrategy
      when :next
        BravuraTemplateNext::ViewStrategy
      when :saas
        BravuraTemplateSaas::ViewStrategy
      else
        BravuraTemplatePrime::ViewStrategy
      end
    end
  end
end
