# spec/concerns/bravura_template_base/blog_controller_concern_spec.rb
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
  let(:posts) { [ post ] }
  let(:guaranteed_setting_service) { instance_double(BravuraTemplateBase::GuaranteedSettingService) }
  let(:presenter) { instance_double("Presenter") }
  let(:view_strategy) { instance_double("BravuraTemplatePrime::ViewStrategy") }

  before do
    # Create a mock Post class
    post_class = class_double("Post").as_stubbed_const

    # Mock scopes and class methods
    allow(post_class).to receive(:recently_published).and_return(posts)
    allow(post_class).to receive(:featured).and_return(posts)
    allow(post_class).to receive(:published).and_return(post_class)

    # Mock ActiveRecord::Relation methods
    allow(post_class).to receive(:find).and_return(post)

    allow(controller).to receive(:current_account).and_return(account)
    allow(BravuraTemplateBase::GuaranteedSettingService).to receive(:for_account).and_return(guaranteed_setting_service)
    allow(guaranteed_setting_service).to receive(:get).and_return("prime")
    allow(BravuraTemplateBase::PresenterFactory).to receive(:create).and_return(presenter)
    allow(BravuraTemplateBase::ViewStrategyFactory).to receive(:create_for).and_return(view_strategy)
    allow(view_strategy).to receive(:template_for).and_return("some_template")
    allow(view_strategy).to receive(:layout).and_return("some_layout")

    # Stub render_with_strategy to avoid rendering views
    allow(controller).to receive(:render_with_strategy)
  end

  describe "#index" do
    it "assigns recently published posts and featured posts" do
      get :index
      expect(assigns(:posts)).to eq(posts)
      expect(assigns(:featured_posts)).to eq(posts)
      expect(controller).to have_received(:render_with_strategy).with(:index)
    end
  end

  describe "#show" do
    context "when the post exists" do
      it "assigns the requested post and related posts" do
        allow(post).to receive(:related_posts).and_return(posts)
        allow(Post).to receive_message_chain(:published, :find).and_return(post)

        get :show, params: { id: "1" }
        expect(assigns(:post)).to eq(post)
        expect(assigns(:related_posts)).to eq(posts)
        expect(controller).to have_received(:render_with_strategy).with(:show)
      end
    end

    context "when the post does not exist" do
      it "renders not found template" do
        allow(Post).to receive_message_chain(:published, :find).and_raise(ActiveRecord::RecordNotFound)
        allow(controller).to receive(:render_not_found)

        get :show, params: { id: "1" }
        expect(controller).to have_received(:render_not_found)
      end
    end
  end
end
