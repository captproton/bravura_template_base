module BravuraTemplateBase
  class Engine < ::Rails::Engine
    isolate_namespace BravuraTemplateBase

    initializer "bravura_template_base.load_available_templates" do |app|
      BravuraTemplateBase.available_templates.each do |template_name|
        begin
          require template_name
        rescue LoadError => e
          app.config.logger.warn "Failed to load template: #{template_name}. Error: #{e.message}"
        end
      end
    end

    initializer "bravura_template_base.assets" do |app|
      BravuraTemplateBase.available_templates.each do |template_name|
        begin
          BravuraTemplateBase.load_template(app, template_name)
        rescue => e
          app.config.logger.warn "Failed to load template assets: #{template_name}. Error: #{e.message}"
        end
      end

      app.config.assets.precompile += %w[
        bravura_template_base/application.js
        bravura_template_base/application.css
      ]
      app.config.assets.paths << Engine.root.join("app/assets/builds/bravura_template_base")
      app.config.assets.paths << Engine.root.join("app", "assets", "stylesheets")
      app.config.assets.paths << Engine.root.join("app", "assets", "javascripts")
    end

    initializer "bravura_template_base.add_view_paths", before: :load_config_initializers do |app|
      ActiveSupport.on_load(:action_controller) do
        prepend_view_path Engine.root.join("app", "views")
      end
    end

    initializer "bravura_template_base.settings_integration" do |app|
      ActiveSupport.on_load(:action_controller) do
        include BravuraTemplateBase::SettingsIntegration
      end
    end
  end
end
