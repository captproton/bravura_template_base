module BravuraTemplateBase
  module BlogControllerConcern
    extend ActiveSupport::Concern

    def index
      @posts = Post.recently_published
      @featured_articles = Post.featured
    end

    def show
      @post = Post.find(params[:id])
      @related_posts = @post.related_posts
    end
  end
end
