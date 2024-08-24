# spec/lib/bravura_template_base/guaranteed_setting_service_spec.rb
require 'spec_helper'
require 'bravura_template_base/guaranteed_setting_service'

# Mock SettingsService if it's not available in the test environment
unless defined?(SettingsService)
  class SettingsService
    def self.for_account(account)
      new
    end

    def [](key)
      nil
    end
  end
end

module BravuraTemplateBase
  RSpec.describe GuaranteedSettingService do
    let(:account) { double('Account') }
    let(:settings_service) { instance_double(SettingsService) }
    let(:default_settings) { instance_double(DefaultSettingsRepository) }
    let(:service) { described_class.new(settings_service, default_settings) }

    before do
      allow(SettingsService).to receive(:for_account).with(account).and_return(settings_service)
      allow(DefaultSettingsRepository).to receive(:new).and_return(default_settings)
    end

    describe '.for_account' do
      it 'returns an instance of GuaranteedSettingService' do
        result = described_class.for_account(account)
        expect(result).to be_a(described_class)
      end

      it 'initializes with SettingsService and DefaultSettingsRepository for the given account' do
        expect(SettingsService).to receive(:for_account).with(account)
        expect(DefaultSettingsRepository).to receive(:new)
        described_class.for_account(account)
      end
    end

    describe '#get' do
      it 'delegates to SettingRetriever' do
        retriever = instance_double(SettingRetriever)
        expect(SettingRetriever).to receive(:new).with(settings_service, default_settings, 'N/A').and_return(retriever)
        expect(retriever).to receive(:get).with('feature.comments')
        service.get('feature.comments')
      end
    end
  end

  RSpec.describe SettingRetriever do
    let(:settings_service) { instance_double(SettingsService) }
    let(:default_settings) { instance_double(DefaultSettingsRepository) }
    let(:fallback_value) { 'N/A' }
    let(:retriever) { described_class.new(settings_service, default_settings, fallback_value) }

    describe '#get' do
      context 'when the setting exists in settings_service' do
        it 'returns the value from the settings service' do
          allow(settings_service).to receive(:[]).with(:feature).and_return(double(comments: true))
          result = retriever.get('feature.comments')
          expect(result).to eq(true)
        end
      end

      context 'when the setting does not exist in settings_service but exists in default_settings' do
        it 'returns the default value' do
          allow(settings_service).to receive(:[]).with(:feature).and_return(nil)
          allow(default_settings).to receive(:get).with('feature.comments').and_return(false)
          result = retriever.get('feature.comments')
          expect(result).to eq("N/A")
        end
      end

      context 'when the setting does not exist in settings_service or default_settings' do
        it 'returns the fallback value' do
          allow(settings_service).to receive(:[]).with(:non_existent).and_return(nil)
          allow(default_settings).to receive(:get).with('non_existent.setting').and_return(nil)
          result = retriever.get('non_existent.setting')
          expect(result).to eq(fallback_value)
        end
      end

      context 'when the category or setting is nil' do
        it 'returns the fallback value' do
          result = retriever.get(nil)
          expect(result).to eq(fallback_value)
        end
      end
    end
  end

  RSpec.describe DefaultSettingsRepository do
    let(:repository) { described_class.new }

    describe '#get' do
      it 'returns default value for existing setting' do
        expect(repository.get('feature.page_size')).to eq(10)
      end

      it 'returns nil for non-existent setting' do
        expect(repository.get('non_existent.setting')).to be_nil
      end

      it 'returns nil when category is nil' do
        expect(repository.get('nil.setting')).to be_nil
      end

      it 'returns nil when setting is nil' do
        expect(repository.get('feature.nil')).to be_nil
      end
    end

    describe 'default values' do
      it 'returns default value for blog_hero_description in general settings' do
        expect(repository.get('general.blog_hero_description')).to eq("Welcome to our blog")
      end

      it 'returns default value for html_lang in general settings' do
        expect(repository.get('general.html_lang')).to eq("en")
      end

      it 'uses the current year in the copyright default for footer settings' do
        expect(repository.get('footer.copyright')).to include(Time.now.year.to_s)
      end
    end
  end
end
