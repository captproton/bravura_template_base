# app/factories/bravura_template_base/presenter_factory.rb

module BravuraTemplateBase
  class PresenterFactory
    def self.create(settings)
      template_name = settings.get("design.template")
      presenter_class = presenter_class_for(template_name)
      presenter_class.new(settings)
    end

    private

    def self.presenter_class_for(template_name)
      case template_name.to_sym
      when :prime
        require_dependency "bravura_template_prime/presenter"
        BravuraTemplatePrime::Presenter
      when :next
        require_dependency "bravura_template_next/presenter"
        BravuraTemplateNext::Presenter
      else
        require_dependency "bravura_template_base/base_presenter"
        BravuraTemplateBase::BasePresenter
      end
    end
  end
end
