require 'spec_helper'

RSpec.describe BravuraTemplateBase do
  let(:app) { build(:app) }

  describe '.load_template' do
    context 'when the template exists' do
      it 'loads the template successfully' do
        expect(app.config.assets.paths).to receive(:<<).with(anything)
        expect(app.config.assets.precompile).to receive(:<<).with("bravura_template/normal/application.css")

        # Mock the engine constant
        normal_engine = Class.new(Rails::Engine)
        stub_const("BravuraTemplate::Normal::Engine", normal_engine)
        allow_any_instance_of(normal_engine).to receive(:root).and_return(Pathname.new("/dummy/path"))

        BravuraTemplateBase.load_template(app, 'normal')
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
