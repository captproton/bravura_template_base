require "bravura_template_base/version"
require "bravura_template_base/engine"
require "bravura_template_base/null_settings"
require "bravura_template_base/settings_integration"
require "bravura_template_base/guaranteed_setting_service"

module BravuraTemplateBase
  class Error < StandardError; end

  mattr_accessor :available_templates
  self.available_templates = [ "bravura_template_prime" ]

  DEFAULT_TEMPLATE = "bravura_template_prime"

  mattr_accessor :set_locale_module

  module TemplateRenderer
    extend ActiveSupport::Concern
    include BravuraTemplateBase::SettingsIntegration

    included do
      include BravuraTemplateBase.set_locale_module if BravuraTemplateBase.set_locale_module
      layout :determine_layout
      before_action :prepend_template_view_path
    end

    def render_in_template(template = action_name)
      template_name = get_setting("design.blog_template_gem") || DEFAULT_TEMPLATE
      render template: "#{template_name}/blog/#{template}"
    end

    private

    def determine_layout
      template_name = get_setting("design.blog_template_gem") || DEFAULT_TEMPLATE
      "layouts/#{template_name}/application"
    end

    def prepend_template_view_path
      template_name = get_setting("design.blog_template_gem") || DEFAULT_TEMPLATE
      path = BravuraTemplateBase.template_view_path(template_name)
      prepend_view_path(path) if path
    end
  end

  class << self
    def register_template(template_name)
      available_templates << template_name unless available_templates.include?(template_name)
    end

    def template_options
      available_templates.map do |template|
        [ template.humanize.titleize, template ]
      end
    end

    def load_template(app, account = nil)
      account ||= create_default_account
      validate_account(account)
      template_name = account.settings_design.blog_template_gem || DEFAULT_TEMPLATE
      load_template_engine(app, template_name, account)
    end

    def logger
      Rails.logger || Logger.new(STDOUT)
    end

    def template_view_path(template_name)
      engine_class = "#{template_name.camelize}::Engine".constantize
      engine_class.root.join("app", "views")
    rescue NameError
      logger.warn "Template engine for #{template_name} not found"
      nil
    end

    private

    def create_default_account
      OpenStruct.new(
        settings_design: OpenStruct.new(blog_template_gem: DEFAULT_TEMPLATE),
        id: 1
      )
    end

    def validate_account(account)
      unless account.respond_to?(:settings_design) && account.respond_to?(:id)
        raise ArgumentError, "account must respond to :settings_design and :id"
      end
    end

    def load_template_engine(app, template_name, account)
      engine_class = "#{template_name.camelize}::Engine".constantize
      configure_assets(app, engine_class, template_name)
    rescue NameError => e
      handle_missing_template(app, template_name, account, e)
    end

    def configure_assets(app, engine_class, template_name)
      app.config.assets.paths << engine_class.root.join("app/javascript")
      app.config.assets.precompile << "#{template_name}/application.css"
    end

    def handle_missing_template(app, template_name, account, error)
      logger.warn "Template #{template_name} not found for account #{account.id}, falling back to default"
      if template_name != DEFAULT_TEMPLATE
        account.settings_design.blog_template_gem = DEFAULT_TEMPLATE
        load_template(app, account)
      else
        raise "Default template #{DEFAULT_TEMPLATE} not found: #{error.message}"
      end
    end
  end
end
