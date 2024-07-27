module BravuraTemplateBase
  module BlogControllerConcern
    extend ActiveSupport::Concern

    included do
      include_template_extensions
    end

    private

    def include_template_extensions
      template_name = current_account.template_name # or however you determine the current template
      extension_module = "#{template_name.camelize}::BlogControllerExtensions".constantize
      self.class.include(extension_module) if extension_module
    end
  end
end
