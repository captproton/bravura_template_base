# lib/bravura_template_base/template_renderer.rb
module BravuraTemplateBase
  module TemplateRenderer
    extend ActiveSupport::Concern
    include BravuraTemplateBase::SettingsIntegration

    included do
      layout :determine_layout
      before_action :prepend_template_view_path
    end

    def render_in_template(template = action_name)
      template_name = get_setting("design.blog_template_gem") || BravuraTemplateBase::DEFAULT_TEMPLATE
      render template: "#{template_name}/blog/#{template}"
    end

    private

    def determine_layout
      template_name = get_setting("design.blog_template_gem") || BravuraTemplateBase::DEFAULT_TEMPLATE
      "layouts/#{template_name}/application"
    end

    def prepend_template_view_path
      template_name = get_setting("design.blog_template_gem") || BravuraTemplateBase::DEFAULT_TEMPLATE
      path = BravuraTemplateBase.template_view_path(template_name)
      prepend_view_path(path) if path
    end
  end
end
