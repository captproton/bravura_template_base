# app/factories/bravura_template_base/view_strategy_factory.rb
module BravuraTemplateBase
  class ViewStrategyFactory
    class UnknownTemplateError < StandardError; end

    class << self
      def create_for(settings:, template_name:, controller_name:, **options)
        new(settings: settings, template_name: template_name, controller_name: controller_name, **options).create
      end
    end

    def initialize(settings:, template_name:, controller_name:, **options)
      @settings = settings
      @template_name = template_name.to_sym
      @controller_name = controller_name
      @options = options
    end

    def create
      strategy_class = strategy_class_for(@template_name)
      strategy_class.new(settings: @settings, controller_name: @controller_name, **@options)
    end

    private

    def strategy_class_for(template)
      case template
      when :prime then BravuraTemplatePrime::ViewStrategy
      when :next then BravuraTemplateNext::ViewStrategy
      when :saas then BravuraTemplateSaas::ViewStrategy
      else
        raise UnknownTemplateError, "Unknown template: #{template}"
      end
    end
  end
end
