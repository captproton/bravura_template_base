require "bravura_template_base/version"
require "bravura_template_base/engine"
require "bravura_template_base/settings_integration"

module BravuraTemplateBase
  class Error < StandardError; end
  mattr_accessor :available_templates
  self.available_templates = [ "bravura_template_normal" ]

  DEFAULT_TEMPLATE = "bravura_template_normal"

  def self.register_template(template_name)
    available_templates << template_name unless available_templates.include?(template_name)
  end

  def self.template_options
    available_templates.map do |template|
      [ template.humanize.titleize, template ]
    end
  end

  def self.load_template(app, account)
    raise ArgumentError, "account must respond to :settings_design and :id" unless account.respond_to?(:settings_design) && account.respond_to?(:id)

    template_name = account.settings_design.blog_template_gem

    begin
      engine_class = "#{template_name.camelize}::Engine".constantize
      app.config.assets.paths << engine_class.root.join("app/javascript")
      app.config.assets.precompile << "#{template_name}/application.css"
    rescue NameError => e
      logger.warn "Template #{template_name} not found for account #{account.id}, falling back to default"
      if template_name != DEFAULT_TEMPLATE
        account.settings_design.blog_template_gem = DEFAULT_TEMPLATE
        load_template(app, account)
      else
        raise "Default template #{DEFAULT_TEMPLATE} not found: #{e.message}"
      end
    end
  end

  def self.logger
    Rails.logger || Logger.new(STDOUT)
  end
end
