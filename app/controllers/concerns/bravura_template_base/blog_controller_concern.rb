# app/controllers/concerns/bravura_template_base/blog_controller_concern.rb
module BravuraTemplateBase
  module BlogControllerConcern
    extend ActiveSupport::Concern

    included do
      before_action :load_settings_and_presenter
      before_action :set_view_strategy
      before_action :set_current_account
    end

    def index
      load_index_data
      render_with_strategy :index
    end

    def show
      load_show_data
      render_with_strategy :show
    rescue ActiveRecord::RecordNotFound
      render_not_found
    end

    private

    def load_index_data
      # Override this method in the main controller to add more data
    end

    def load_show_data
      # Override this method in the main controller to load the post and related data
    end

    def set_current_account
      current_account = @posts.first&.account || @post&.account
      @current_account = current_account
    end
    def set_view_strategy
      current_settings = GuaranteedSettingService.for_account(current_account)
      @view_strategy = BravuraTemplateBase::ViewStrategyFactory.create_for(
        settings: current_settings,
        template_name: current_settings.get("design.template")
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
  end
end
