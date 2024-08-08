# app/factories/bravura_template_base/presenter_factory.rb

module BravuraTemplateBase
  class PresenterFactory
    def self.create(settings)
      # template_name = settings.get("design.template")
      # FIXME: template name is static
      template_name = "prime"
      presenter_class = presenter_class_for(template_name)
      presenter_class.new(settings)
    end

    def self.constant_setter_for(template_name)
      case template_name.to_sym
      when :prime
        BravuraTemplatePrime::ConstantSetter
      when :next
        BravuraTemplateNext::ConstantSetter
      else
        BravuraTemplateBase::ConstantSetter
      end
    end

    private

    def self.presenter_class_for(template_name)
      case template_name.to_sym
      when :prime
        BravuraTemplatePrime::Presenter
      when :next
        BravuraTemplateNext::Presenter
      else
        BasePresenter
      end
    end
  end
end
