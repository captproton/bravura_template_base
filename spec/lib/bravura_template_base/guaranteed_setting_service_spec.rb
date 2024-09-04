# spec/lib/bravura_template_base/guaranteed_setting_service_spec.rb

require 'spec_helper'
require 'bravura_template_base/guaranteed_setting_service'
require_relative '../../support/mocks/settings_service'

module BravuraTemplateBase
  RSpec.describe GuaranteedSettingService do
    let(:account) { double('Account') }
    let(:settings) { MockSettingsService.new }
    let(:default_settings) { instance_double("BravuraTemplateBase::DefaultSettingsRepository") }
    let(:setting_retriever) { instance_double("BravuraTemplateBase::SettingRetriever") }

    before do
      stub_const("SettingsService", MockSettingsService)
      allow(BravuraTemplateBase::DefaultSettingsRepository).to receive(:new).and_return(default_settings)
      allow(BravuraTemplateBase::SettingRetriever).to receive(:new).and_return(setting_retriever)
    end

    describe '.for_account' do
      it 'returns an instance of GuaranteedSettingService' do
        result = described_class.for_account(account)
        expect(result).to be_a(described_class)
      end

      it 'initializes with SettingsService and DefaultSettingsRepository for the given account' do
        expect(SettingsService).to receive(:for_account).with(account)
        expect(BravuraTemplateBase::DefaultSettingsRepository).to receive(:new)
        described_class.for_account(account)
      end
    end

    describe '#get' do
      let(:service) { described_class.new(settings, default_settings) }

      it 'delegates to SettingRetriever' do
        expect(BravuraTemplateBase::SettingRetriever).to receive(:new).with(settings, default_settings, 'N/A').and_return(setting_retriever)
        expect(setting_retriever).to receive(:get).with('feature.comments')
        service.get('feature.comments')
      end
    end
  end
end
