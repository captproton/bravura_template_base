# bravura_template_base/spec/lib/bravura_template_base/guaranteed_setting_service_spec.rb

require 'rails_helper'
require 'active_support/all'
require 'bravura_template_base/guaranteed_setting_service'


module BravuraTemplateBase
  RSpec.describe GuaranteedSettingService do
    let(:account) { instance_double("Account") }
    let(:settings_service) { instance_double("SettingsService") }

    before do
      allow(SettingsService).to receive(:for_account).with(account).and_return(settings_service)
    end

    describe '.for_account' do
      it 'creates a new instance with SettingsService for the given account' do
        expect(GuaranteedSettingService.for_account(account)).to be_a(GuaranteedSettingService)
      end
    end

    describe '#get' do
      let(:service) { GuaranteedSettingService.new(settings_service) }

      context 'when the setting exists' do
        it 'returns the value from SettingsService' do
          allow(settings_service).to receive(:get).with(:feature).and_return({ page_size: 20 })
          expect(service.get(:feature).page_size).to eq(20)
        end
      end

      context 'when the setting does not exist' do
        it 'returns a DefaultSetting with default values' do
          allow(settings_service).to receive(:get).with(:feature).and_return(nil)
          expect(service.get(:feature).page_size).to eq(10) # default value
        end
      end
    end

    describe GuaranteedSettingService::DefaultSetting do
      let(:default_setting) { GuaranteedSettingService::DefaultSetting.new(:feature) }

      it 'returns default values for existing keys' do
        expect(default_setting.page_size).to eq(10)
        expect(default_setting.comments).to eq(false)
      end

      it 'raises NoMethodError for non-existing keys' do
        expect { default_setting.non_existing_key }.to raise_error(NoMethodError)
      end

      it 'responds to existing methods' do
        expect(default_setting).to respond_to(:page_size)
        expect(default_setting).to respond_to(:comments)
      end

      it 'does not respond to non-existing methods' do
        expect(default_setting).not_to respond_to(:non_existing_method)
      end
    end
  end
end
