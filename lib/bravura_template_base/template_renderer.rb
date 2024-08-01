# lib/bravura_template_base/template_renderer.rb
module BravuraTemplateBase
  module TemplateRenderer
    extend ActiveSupport::Concern

    TEMPLATE_NAME = "bravura_template_prime"

    included do
      layout "layouts/#{TEMPLATE_NAME}/application"
      before_action :prepend_template_view_path
    end

    def render_in_template(template = action_name)
      render template: "#{TEMPLATE_NAME}/blog/#{template}"
    end

    private

    def prepend_template_view_path
      path = BravuraTemplateBase.template_view_path(TEMPLATE_NAME)
      prepend_view_path(path) if path
    end
  end
end
