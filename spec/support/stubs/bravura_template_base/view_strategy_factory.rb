# spec/support/stubs/bravura_template_base/view_strategy_factory.rb

module BravuraTemplateBase
  class ViewStrategyFactory
    def self.create_for(settings:, template_name:, **options)
      BravuraTemplatePrime::ViewStrategy.new(settings: settings, **options)
    end
  end
end
