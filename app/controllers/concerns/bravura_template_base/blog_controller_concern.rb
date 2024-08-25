# app/controllers/concerns/bravura_template_base/blog_controller_concern.rb
module BravuraTemplateBase
  module BlogControllerConcern
    extend ActiveSupport::Concern
    include BravuraTemplateBase::BaseControllerConcern
    include Pagy::Backend  # Add this line to include Pagy

    def index
      load_posts_data
      render_with_strategy :index
    end

    def show
      load_post_data
      render_with_strategy :show
    rescue ActiveRecord::RecordNotFound
      render_not_found
    end

    def category
      load_category_data
      render_with_strategy :category
    rescue ActiveRecord::RecordNotFound
      render_not_found
    end

    def tag
      load_tag_data
      render_with_strategy :tag
    rescue ActiveRecord::RecordNotFound
      render_not_found
    end

    private

    def load_posts_data
      # Override this method in the main controller to load posts data
    end

    def load_post_data
      # Override this method in the main controller to load specific post data
    end

    def load_category_data
      # Override this method in the main controller to load category-specific posts
    end

    def load_tag_data
      # Override this method in the main controller to load tag-specific posts
    end
  end
end
