module BravuraTemplateBase
  AVAILABLE_TEMPLATES = [ "bravura_template_normal", "bravura_template_product_updates" ]
  DEFAULT_TEMPLATE = "bravura_template_normal"

  def self.load_template(app, account)
    raise ArgumentError, "account must respond to :settings and :id" unless account.respond_to?(:settings) && account.respond_to?(:id)

    template_name = account.settings.design.blog_template_gem

    begin
      engine_class = "#{template_name.camelize}::Engine".constantize
      app.config.assets.paths << engine_class.root.join("app/javascript")
      app.config.assets.precompile << "#{template_name}/application.css"
    rescue NameError => e
      logger.warn "Template #{template_name} not found for account #{account.id}, falling back to default"
      if template_name != DEFAULT_TEMPLATE
        account.settings.design.blog_template_gem = DEFAULT_TEMPLATE
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
