# app/controllers/concerns/bravura_template_base/blog_controller_concern.rb

module BravuraTemplateBase
  module BlogControllerConcern
    extend ActiveSupport::Concern

    included do
      before_action :load_settings_and_presenter
      before_action :set_view_strategy
      # before_action :set_publication_constants
    end

    # def index
    #   # Common index logic here
    #   @posts = Post.published.order(published_at: :desc).page(params[:page])
    #   @featured_posts = Post.featured.limit(3)
    #   @tags = Tag.all
    #   render_with_strategy :index
    # end

    # def show
    #   @post = Post.published.find(params[:id])
    #   @related_posts = @post.related_posts.limit(3)
    #   render_with_strategy :show
    # rescue ActiveRecord::RecordNotFound
    #   render_not_found
    # end

    private

    def featured
      @featured_posts = Post.featured
    end

    def archives
      @archived_posts = Post.archived.page(params[:page])
    end

    def set_view_strategy
      settings = GuaranteedSettingService.for_account(ActsAsTenant.current_tenant)
      @view_strategy = ViewStrategyFactory.create(settings: settings)
    end

    def load_settings_and_presenter
      @settings ||= GuaranteedSettingService.for_account(ActsAsTenant.current_tenant)
      @presenter = PresenterFactory.create(@settings)
    end

    def set_publication_constants
      constant_setter_class = PresenterFactory.constant_setter_for(@settings)
      constant_setter_class.new(@presenter, view_context).set_all
    end

    def render_with_strategy(action)
      render template: @view_strategy.template_for(action), layout: @view_strategy.layout
    end

    def render_not_found
      render template: "shared/not_found", status: :not_found
    end
  end
end
