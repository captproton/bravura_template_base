# spec/lib/bravura_template_base/guaranteed_setting_service_spec.rb

require 'spec_helper'
require 'bravura_template_base/guaranteed_setting_service'

module BravuraTemplateBase
  RSpec.describe GuaranteedSettingService do
    let(:account) { double('Account') }
    let(:settings_service) { double('SettingsService') }
    let(:service) { described_class.new(settings_service) }


    before do
      # Stub the SettingsService from the main app with the for_account method
      stub_const("::SettingsService", Class.new do
        def self.for_account(account)
          # Return a new instance of this stubbed class
          new
        end
      end)
    end

    describe '.for_account' do
      it 'creates a new instance with settings for the given account' do
        expect(::SettingsService).to receive(:for_account).with(account).and_call_original
        result = described_class.for_account(account)
        expect(result).to be_a(described_class)
        expect(result.instance_variable_get(:@settings_service)).to be_a(::SettingsService)
      end
    end


    describe '#get' do
      context 'when the setting exists' do
        it 'returns the value from the settings service' do
          expect(settings_service).to receive(:get).with('feature.comments').and_return(true)
          result = service.get('feature.comments')
          expect(result).to eq(true)
        end
      end

      context 'when the setting does not exist' do
        it 'returns a DefaultSetting object' do
          expect(settings_service).to receive(:get).with('feature.nonexistent').and_return(nil)
          result = service.get('feature.nonexistent')
          expect(result).to be_a(GuaranteedSettingService::DefaultSetting)
        end
      end
    end

    describe GuaranteedSettingService::DefaultSetting do
      let(:default_setting) { described_class.new(:feature) }

      it 'returns default values for known settings' do
        expect(default_setting.page_size).to eq(10)
        expect(default_setting.comments).to eq(false)
        expect(default_setting.watermark).to eq(true)
      end

      it 'returns nil for unknown settings' do
        expect(default_setting.unknown_setting).to be_nil
      end

      it 'responds to known methods' do
        expect(default_setting).to respond_to(:page_size)
        expect(default_setting).to respond_to(:comments)
      end

      it 'does not respond to unknown methods' do
        expect(default_setting).not_to respond_to(:unknown_method)
      end

      it 'handles nested settings' do
        general_setting = described_class.new(:general)
        expect(general_setting.blog_hero_description).to eq("Welcome to our blog")
        expect(general_setting.html_lang).to eq("en")
      end

      it 'uses the current year in the copyright default' do
        footer_setting = described_class.new(:footer)
        expect(footer_setting.copyright).to include(Time.current.year.to_s)
      end
    end
  end
end
