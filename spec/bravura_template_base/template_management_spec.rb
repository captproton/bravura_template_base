require 'spec_helper'

RSpec.describe BravuraTemplateBase do
  let(:app) { OpenStruct.new(config: OpenStruct.new(assets: OpenStruct.new(paths: [], precompile: []))) }

  describe '.load_template' do
    context 'when the template exists' do
      let(:account) { build(:account, :with_normal_template) }

      it 'loads the template successfully' do
        expect(app.config.assets.paths).to receive(:<<).with(anything)
        expect(app.config.assets.precompile).to receive(:<<).with("bravura_template_normal/application.css")

        normal_engine = Class.new(Rails::Engine)
        stub_const("BravuraTemplateNormal::Engine", normal_engine)
        allow_any_instance_of(normal_engine).to receive(:root).and_return(Pathname.new("/dummy/path"))

        BravuraTemplateBase.load_template(app, account)
      end
    end

    context 'when the template does not exist' do
      let(:account) { build(:account, :with_non_existent_template) }

      it 'falls back to the default template' do
        allow(BravuraTemplateBase).to receive(:load_template).and_call_original
        allow(BravuraTemplateBase).to receive(:logger).and_return(Logger.new(nil))
        expect(BravuraTemplateBase.logger).to receive(:warn).with(/Template non_existent_template not found for account \d+, falling back to default/)

        normal_engine = Class.new(Rails::Engine)
        stub_const("BravuraTemplateNormal::Engine", normal_engine)
        allow_any_instance_of(normal_engine).to receive(:root).and_return(Pathname.new("/dummy/path"))

        expect(app.config.assets.paths).to receive(:<<).with(anything)
        expect(app.config.assets.precompile).to receive(:<<).with("bravura_template_normal/application.css")

        BravuraTemplateBase.load_template(app, account)
      end
    end
  end
end
