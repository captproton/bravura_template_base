require 'rails_helper'

RSpec.describe BravuraTemplateBase::BlogControllerConcern, type: :controller do
  controller(ApplicationController) do
    include BravuraTemplateBase::BlogControllerConcern

    def current_account
      @current_account ||= Account.new
    end

    def index
      super
      render plain: 'index'
    end

    def show
      super
      render plain: 'show'
    end
  end

  let(:account) { instance_double(Account) }
  let(:post) { instance_double(Post) }
  let(:posts) { [post] }

  before do
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe "#index" do
    it "assigns published posts and featured articles" do
      allow(Post).to receive(:recently_published).and_return(posts)
      allow(Post).to receive(:featured).and_return(posts)
      get :index
      expect(assigns(:posts)).to eq(posts)
      expect(assigns(:featured_articles)).to eq(posts)
    end
  end

  describe "#show" do
    context "when the post exists" do
      it "assigns the requested post and related posts" do
        allow(Post).to receive(:find).with("1").and_return(post)
        allow(post).to receive(:related_posts).and_return(posts)
        get :show, params: { id: "1" }
        expect(assigns(:post)).to eq(post)
        expect(assigns(:related_posts)).to eq(posts)
      end
    end

    context "when the post does not exist" do
      it "raises an ActiveRecord::RecordNotFound error" do
        allow(Post).to receive(:find).with("1").and_raise(ActiveRecord::RecordNotFound)
        expect {
          get :show, params: { id: "1" }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
