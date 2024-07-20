# bravura_template_base/lib/bravura_template_base.rb

require 'bravura_template_base/settings_integration'

module BravuraTemplateBase
  class Engine < ::Rails::Engine
    isolate_namespace BravuraTemplateBase

    initializer 'bravura_template_base.settings_integration' do |app|
      ActiveSupport.on_load(:action_controller) do
        include BravuraTemplateBase::SettingsIntegration
      end
    end
  end
end
