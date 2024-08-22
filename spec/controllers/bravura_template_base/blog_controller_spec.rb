# spec/controllers/bravura_template_base/blog_controller_spec.rb

require 'rails_helper'

RSpec.describe BravuraTemplateBase::BlogController, type: :controller do
  routes { BravuraTemplateBase::Engine.routes }

  describe "#index" do
    it "renders the correct template and assigns posts and featured articles" do
      posts = [double('Post')]
      featured_articles = [double('FeaturedArticle')]

      allow(Post).to receive(:recently_published).and_return(posts)
      allow(Post).to receive(:featured).and_return(featured_articles)

      get :index

      expect(response).to have_http_status(:success)
      expect(response).to render_template('bravura_template_base/blog/index')
      expect(assigns(:posts)).to eq(posts)
      expect(assigns(:featured_articles)).to eq(featured_articles)
    end
  end

  describe "#show" do
    it "renders the correct template and assigns post and related posts" do
      post = double('Post')
      related_posts = [double('RelatedPost')]

      allow(Post).to receive(:find).with('1').and_return(post)
      allow(post).to receive(:related_posts).and_return(related_posts)

      get :show, params: { id: '1' }

      expect(response).to have_http_status(:success)
      expect(response).to render_template('bravura_template_base/blog/show')
      expect(assigns(:post)).to eq(post)
      expect(assigns(:related_posts)).to eq(related_posts)
    end
  end
end
