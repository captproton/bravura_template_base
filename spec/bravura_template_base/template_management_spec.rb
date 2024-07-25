require 'spec_helper'

RSpec.describe BravuraTemplateBase do
  let(:app) { OpenStruct.new(config: OpenStruct.new(assets: OpenStruct.new(paths: [], precompile: []))) }

  describe '.load_template' do
    context 'when the template exists' do
      let(:account) { build(:account, :with_prime_template) }

      it 'loads the template successfully' do
        expect(app.config.assets.paths).to receive(:<<).with(anything)
        expect(app.config.assets.precompile).to receive(:<<).with("bravura_template_prime/application.css")

        prime_engine = Class.new(Rails::Engine)
        stub_const("BravuraTemplatePrime::Engine", prime_engine)
        allow_any_instance_of(prime_engine).to receive(:root).and_return(Pathname.new("/dummy/path"))

        BravuraTemplateBase.load_template(app, account)
      end
    end

    context 'when the template does not exist' do
      let(:account) { build(:account, :with_non_existent_template) }

      it 'falls back to the default template' do
        allow(BravuraTemplateBase).to receive(:load_template).and_call_original
        logger = instance_double(Logger)
        allow(BravuraTemplateBase).to receive(:logger).and_return(logger)
        expect(logger).to receive(:warn).with(/Template non_existent_template not found for account \d+, falling back to default/)

        prime_engine = Class.new(Rails::Engine)
        stub_const("BravuraTemplatePrime::Engine", prime_engine)
        allow_any_instance_of(prime_engine).to receive(:root).and_return(Pathname.new("/dummy/path"))

        expect(app.config.assets.paths).to receive(:<<).with(anything)
        expect(app.config.assets.precompile).to receive(:<<).with("bravura_template_prime/application.css")

        BravuraTemplateBase.load_template(app, account)

        expect(account.settings_design.blog_template_gem).to eq('bravura_template_prime')
      end
    end
  end
end
