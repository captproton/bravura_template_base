# app/controllers/concerns/bravura_template_base/blog_controller_concern.rb
module BravuraTemplateBase
  module BlogControllerConcern
    extend ActiveSupport::Concern

    included do
      before_action :load_settings_and_presenter
      before_action :set_view_strategy
    end

    def index
      @featured_posts = @posts.featured
      # FIXME: featured_posts should be renamed to featured_articles in the spec and in the controller concern
      render_with_strategy :index
    end

    def show
      @related_posts = @post.related_posts
      render_with_strategy :show
    rescue ActiveRecord::RecordNotFound
      render_not_found
    end

    private

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

    # def render_with_strategy(action)
    #   render template: @view_strategy.template_for(action), layout: @view_strategy.layout
    # end
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
