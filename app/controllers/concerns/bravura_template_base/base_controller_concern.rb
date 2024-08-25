# app/controllers/concerns/bravura_template_base/base_controller_concern.rb
module BravuraTemplateBase
  module BaseControllerConcern
    extend ActiveSupport::Concern

    included do
      before_action :load_settings_and_presenter
      before_action :set_view_strategy
      before_action :set_current_account
    end

    private

    def set_current_account
      current_account = Current.account
      @current_account = current_account
    end

    def set_view_strategy
      current_settings = GuaranteedSettingService.for_account(current_account)
      @view_strategy = BravuraTemplateBase::ViewStrategyFactory.create_for(
        settings: current_settings,
        template_name: current_settings.get("design.template"),
        controller_name: controller_name
      )
    end

    def load_settings_and_presenter
      @settings ||= GuaranteedSettingService.for_account(current_account)
      @presenter = BravuraTemplateBase::PresenterFactory.create(@settings)
    end

    def render_with_strategy(action)
      template = @view_strategy.template_for(action)
      layout = @view_strategy.layout
      Rails.logger.debug "Rendering template: #{template}, layout: #{layout}"
      render template: template, layout: layout
    rescue => e
      Rails.logger.error "Error in render_with_strategy: #{e.message}"
      raise
    end

    def render_not_found
      render template: "shared/not_found", status: :not_found
    end

    def render_error
      render template: "shared/error", status: :internal_server_error
    end
  end
end
