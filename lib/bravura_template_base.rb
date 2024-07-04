require "bravura_template_base/engine"
require "bravura_template_base/version"

module BravuraTemplateBase
  AVAILABLE_TEMPLATES = [ "normal" ]
  DEFAULT_TEMPLATE = "normal"

  def self.load_template(app, template_name)
    engine = "BravuraTemplate::#{template_name.camelize}::Engine".constantize
    app.config.assets.paths << engine.root.join("app/javascript")
    app.config.assets.precompile << "bravura_template/#{template_name}/application.css"
  rescue NameError
    logger.warn "Template #{template_name} not found, falling back to default"
    load_template(app, DEFAULT_TEMPLATE) unless template_name == DEFAULT_TEMPLATE
  end

  def self.logger
    Rails.logger || Logger.new(STDOUT)
  end
end
