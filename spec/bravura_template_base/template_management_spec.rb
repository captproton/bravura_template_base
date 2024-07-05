require 'spec_helper'

RSpec.describe BravuraTemplateBase do
  let(:app) { build(:app) }

  before do
    # Mock an account that responds to :settings and :id
    account_double = double("Account", settings: true, id: 1)
    allow(app).to receive(:account).and_return(account_double)
  end

  describe '.load_template' do
    context 'when the template exists' do
      it 'loads the template successfully' do
        app = double("App", config: double("Config", assets: double("Assets", paths: [], precompile: [])))
        account = double("Account", settings: double("Settings", design: double("Design", blog_template_gem: "bravura_template-normal")), id: 1)

        expect { BravuraTemplateBase.load_template(app, account) }.not_to raise_error
      end
    end

    context 'when the template does not exist' do
      it 'falls back to the default template' do
        non_existent_template = 'non_existent'

        allow(BravuraTemplateBase).to receive(:load_template).and_call_original
        allow(BravuraTemplateBase).to receive(:logger).and_return(Logger.new(nil))
        expect(BravuraTemplateBase.logger).to receive(:warn).with("Template #{non_existent_template} not found, falling back to default")

        # Mock the default template engine
        default_engine = Class.new(Rails::Engine)
        stub_const("BravuraTemplate::Normal::Engine", default_engine)
        allow_any_instance_of(default_engine).to receive(:root).and_return(Pathname.new("/dummy/path"))

        # Expect the default template to be loaded
        expect(app.config.assets.paths).to receive(:<<).with(anything)
        expect(app.config.assets.precompile).to receive(:<<).with("bravura_template/normal/application.css")

        BravuraTemplateBase.load_template(app, non_existent_template)
      end
    end
  end
end
