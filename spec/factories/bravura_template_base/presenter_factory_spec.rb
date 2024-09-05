# spec/factories/bravura_template_base/presenter_factory_spec.rb

require 'rails_helper'

# Stub classes
module BravuraTemplatePrime
  class Presenter < BravuraTemplateBase::BasePresenter; end
end

module BravuraTemplateNext
  class Presenter < BravuraTemplateBase::BasePresenter; end
end

RSpec.describe BravuraTemplateBase::PresenterFactory do
  let(:settings) { instance_double("BravuraTemplateBase::GuaranteedSettingService") }

  describe '.create' do
    context 'when template is prime' do
      before do
        allow(settings).to receive(:get).with("design.template").and_return("prime")
        allow(BravuraTemplateBase::PresenterFactory).to receive(:require_dependency).with('bravura_template_prime/presenter')
      end

      it 'creates a BravuraTemplatePrime::Presenter' do
        presenter = described_class.create(settings)
        expect(presenter).to be_a(BravuraTemplatePrime::Presenter)
      end

      it 'requires the prime presenter dependency' do
        expect(BravuraTemplateBase::PresenterFactory).to receive(:require_dependency).with('bravura_template_prime/presenter')
        described_class.create(settings)
      end
    end

    context 'when template is next' do
      before do
        allow(settings).to receive(:get).with("design.template").and_return("next")
        allow(BravuraTemplateBase::PresenterFactory).to receive(:require_dependency).with('bravura_template_next/presenter')
      end

      it 'creates a BravuraTemplateNext::Presenter' do
        presenter = described_class.create(settings)
        expect(presenter).to be_a(BravuraTemplateNext::Presenter)
      end

      it 'requires the next presenter dependency' do
        expect(BravuraTemplateBase::PresenterFactory).to receive(:require_dependency).with('bravura_template_next/presenter')
        described_class.create(settings)
      end
    end

    context 'when template is unknown' do
      before do
        allow(settings).to receive(:get).with("design.template").and_return("unknown")
        allow(BravuraTemplateBase::PresenterFactory).to receive(:require_dependency).with('bravura_template_base/base_presenter')
      end

      it 'creates a BravuraTemplateBase::BasePresenter' do
        presenter = described_class.create(settings)
        expect(presenter).to be_a(BravuraTemplateBase::BasePresenter)
      end

      it 'requires the base presenter dependency' do
        expect(BravuraTemplateBase::PresenterFactory).to receive(:require_dependency).with('bravura_template_base/base_presenter')
        described_class.create(settings)
      end
    end
  end
end
