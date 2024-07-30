# lib/bravura_template_base/template_renderer.rb
module BravuraTemplateBase
  module TemplateRenderer
    extend ActiveSupport::Concern

    included do
      layout :determine_layout
      before_action :prepend_template_view_path
    end

    def render_in_template(template = action_name)
      render template: "#{template_name}/blog/#{template}"
    end

    private

    def determine_layout
      "layouts/#{template_name}/application"
    end

    def prepend_template_view_path
      path = BravuraTemplateBase.template_view_path(template_name)
      prepend_view_path(path) if path
    end

    def template_name
      @template_name ||= begin
        design_settings = Current.account.settings_design
        design_settings&.blog_template_gem || BravuraTemplateBase::DEFAULT_TEMPLATE
      end
    end
  end
end
