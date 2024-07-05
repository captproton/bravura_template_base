module BravuraTemplateBase
  class Engine < ::Rails::Engine
    isolate_namespace BravuraTemplateBase

    initializer "bravura_template_base.assets" do |app|
      BravuraTemplateBase::AVAILABLE_TEMPLATES.each do |template_name|
        BravuraTemplateBase.load_template(app, template_name)
      end
    end
  end
end
