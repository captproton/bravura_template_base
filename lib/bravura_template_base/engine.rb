# lib/bravura_template_base/engine.rb
module BravuraTemplateBase
  class Engine < ::Rails::Engine
    isolate_namespace BravuraTemplateBase

    config.autoload_paths << File.expand_path("../app/controllers", __FILE__)

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end

    initializer "bravura_template_base.load_available_templates" do |app|
      BravuraTemplateBase.available_templates.each do |template_name|
        begin
          require template_name
        rescue LoadError => e
          BravuraTemplateBase.logger.warn "Failed to load template: #{template_name}. Error: #{e.message}"
        end
      end
    end

    initializer "bravura_template_base.assets", group: :all do |app|
      if app.config.respond_to?(:assets)
        BravuraTemplateBase.available_templates.each do |template_name|
          begin
            BravuraTemplateBase.load_template(app)
          rescue StandardError => e
            BravuraTemplateBase.logger.warn "Failed to load template assets: #{template_name}. Error: #{e.message}"
          end
        end
        app.config.assets.precompile += %w[
          bravura_template_base/application.js
          bravura_template_base/application.css
        ]
      else
        BravuraTemplateBase.logger.warn "Asset pipeline is not available in this environment."
      end
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

    # Add this new initializer to ensure the engine's views are available
    initializer "bravura_template_base.set_view_paths" do |app|
      ActiveSupport.on_load(:action_controller) do
        append_view_path File.expand_path("../../app/views", __FILE__)
      end
    end
  end
end
