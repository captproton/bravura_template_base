# spec/lib/bravura_template_base/settings_integration_spec.rb
require 'rails_helper'

RSpec.describe BravuraTemplateBase::SettingsIntegration do
  let(:dummy_class) do
    Class.new do
      include BravuraTemplateBase::SettingsIntegration
      attr_accessor :current_account
    end
  end
  let(:instance) { dummy_class.new }
  let(:current_account) { Struct.new(:id).new(1) }
  let(:settings_service) { class_double('SettingsService') }
  let(:mock_settings) { { general: { site_name: 'Test Blog' }, design: { font_family: 'Arial' } } }
  let(:mock_cache) { double('cache') }

  before do
    instance.current_account = current_account
    stub_const('SettingsService', settings_service)
    allow(settings_service).to receive(:for_account).and_return(mock_settings)
    allow(settings_service).to receive(:clear_cache_for_account)
  end

  describe '#all_settings' do
    context 'when Rails.cache is available' do
      before do
        stub_const('Rails', double('Rails', cache: mock_cache))
        allow(mock_cache).to receive(:fetch).and_yield
      end

      it 'fetches settings from cache' do
        expect(mock_cache).to receive(:fetch).with("account_settings_1", expires_in: 1.hour)
        instance.all_settings
      end
    end

    context 'when Rails.cache is not available' do
      before do
        stub_const('Rails', double('Rails', cache: nil))
      end

      it 'fetches settings directly from SettingsService' do
        expect(settings_service).to receive(:for_account).with(current_account)
        instance.all_settings
      end
    end

    it 'returns the settings' do
      expect(instance.all_settings).to eq(mock_settings)
    end
  end

  describe '#get_setting' do
    it 'retrieves nested settings correctly' do
      expect(instance.get_setting('general.site_name')).to eq('Test Blog')
      expect(instance.get_setting('design.font_family')).to eq('Arial')
    end

    it 'returns nil for non-existent settings' do
      expect(instance.get_setting('non.existent.setting')).to be_nil
    end

    it 'returns nil for partially existing settings' do
      expect(instance.get_setting('general.non_existent')).to be_nil
    end
  end

  describe '#invalidate_settings_cache' do
    context 'when Rails.cache is available' do
      before do
        stub_const('Rails', double('Rails', cache: mock_cache))
      end

      it 'deletes the cache for the current account' do
        expect(mock_cache).to receive(:delete).with("account_settings_1")
        instance.invalidate_settings_cache
      end
    end

    context 'when Rails.cache is not available' do
      before do
        stub_const('Rails', double('Rails', cache: nil))
      end

      it 'does not attempt to delete the cache' do
        expect { instance.invalidate_settings_cache }.not_to raise_error
      end
    end

    it 'clears the cache for the current account in SettingsService' do
      expect(settings_service).to receive(:clear_cache_for_account).with(current_account)
      instance.invalidate_settings_cache
    end

    it 'resets the @all_settings instance variable' do
      instance.instance_variable_set(:@all_settings, mock_settings)
      instance.invalidate_settings_cache
      expect(instance.instance_variable_get(:@all_settings)).to be_nil
    end
  end
end
