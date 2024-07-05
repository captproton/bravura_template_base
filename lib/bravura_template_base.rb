module BravuraTemplateBase
  AVAILABLE_TEMPLATES = [ "bravura_template-normal", "bravura_template-product_updates" ]  # Add all available templates here
  DEFAULT_TEMPLATE = "bravura_template-normal"

  def self.load_template(app, account)
    raise ArgumentError, "account must respond to :settings and :id" unless account.respond_to?(:settings) && account.respond_to?(:id)

    settings_design = account.settings.design
    template_name = settings_design.blog_template_gem || DEFAULT_TEMPLATE

    engine = "#{template_name.camelize}::Engine".constantize
    app.config.assets.paths << engine.root.join("app/javascript")
    app.config.assets.precompile << "#{template_name}/application.css"
  rescue NameError
    logger.warn "Template #{template_name} not found for account #{account.id}, falling back to default"
    load_template(app, OpenStruct.new(settings: OpenStruct.new(design: OpenStruct.new(blog_template_gem: DEFAULT_TEMPLATE)))) unless template_name == DEFAULT_TEMPLATE
  end

  def self.logger
    Rails.logger || Logger.new(STDOUT)
  end
end
