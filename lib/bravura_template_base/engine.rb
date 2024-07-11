module BravuraTemplateBase
  class Engine < ::Rails::Engine
    isolate_namespace BravuraTemplateBase

    initializer "bravura_template_base.load_available_templates" do |app|
      BravuraTemplateBase.available_templates.each do |template_name|
        begin
          require template_name
        rescue LoadError => e
          Rails.logger.warn "Failed to load template: #{template_name}. Error: #{e.message}"
        end
      end
    end

    initializer "bravura_template_base.assets" do |app|
      BravuraTemplateBase.available_templates.each do |template_name|
        begin
          BravuraTemplateBase.load_template(app, template_name)
        rescue => e
          Rails.logger.warn "Failed to load template assets: #{template_name}. Error: #{e.message}"
        end
      end

      app.config.assets.precompile += %w[
        bravura_template_base/application.js
        bravura_template_base/application.css
      ]
      app.config.assets.paths << root.join("app/assets/builds/bravura_template_base")
      app.config.assets.paths << root.join("app", "assets", "stylesheets")
      app.config.assets.paths << root.join("app", "assets", "javascripts")
    end

    initializer "bravura_template_base.add_view_paths", before: :load_config_initializers do |app|
      ActiveSupport.on_load(:action_controller) do
        BravuraTemplateBase.available_templates.each do |template_name|
          # find the engine that matches the template name indirectly because Rails::Engine.find is not available
          all_engines = Rails::Engine.subclasses
          # creates an array of one engine
          filtered_engines = all_engines.select do |engine|
            engine.engine_name.include?(template_name)
          end
          # gets the engine
          template_engine = filtered_engines.first
          # adds the engine's view path to the beginning of the view path stack
          prepend_view_path template_engine.root.join("app", "views")
        end
      end
    end
  end
end
