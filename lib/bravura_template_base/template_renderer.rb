# lib/bravura_template_base/template_renderer.rb
module BravuraTemplateBase
  module TemplateRenderer
    extend ActiveSupport::Concern
    include BravuraTemplateBase::SettingsIntegration

    included do
      layout :determine_layout
    end

    def render_in_template
      template_name = get_setting("design.blog_template_gem") || BravuraTemplateBase::DEFAULT_TEMPLATE
      prepend_view_path BravuraTemplateBase.template_view_path(template_name)
      render template: "#{template_name}/blog/index"
    end

    private

    def determine_layout
      template_name = get_setting("design.blog_template_gem") || BravuraTemplateBase::DEFAULT_TEMPLATE
      "layouts/#{template_name}/application"
    end
  end
end
