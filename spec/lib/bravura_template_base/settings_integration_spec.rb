require 'rails_helper'
require 'bravura_template_base/guaranteed_setting_service'

module BravuraTemplateBase
  RSpec.describe SettingsIntegration do
    let(:dummy_class) do
      Class.new do
        def self.helper_method(*); end
        include BravuraTemplateBase::SettingsIntegration
        attr_accessor :current_account

        class << self
          attr_accessor :cache_store
        end
      end
    end

    let(:instance) { dummy_class.new }
    let(:current_account) { double('Account', id: 1) }
    let(:mock_cache) { ActiveSupport::Cache::MemoryStore.new }
    let(:guaranteed_settings) { instance_double("BravuraTemplateBase::GuaranteedSettingService") }

    before do
      dummy_class.cache_store = mock_cache
      instance.current_account = current_account
      allow(BravuraTemplateBase::GuaranteedSettingService).to receive(:for_account).with(current_account).and_return(guaranteed_settings)
    end

    describe '#all_settings' do
      let(:mock_settings) do
        {
          feature: { watermark: true, pagination: true },
          general: { site_name: 'Test Blog', html_lang: 'en' },
          design: { font_family: 'Arial', site_mode_id: 2 },
          cta_button_setup: { show_cta_button: true },
          email_newsletter_setup: { header_enabled: false },
          footer: { footer_description: 'Test Footer' },
          navigation: { logo_text: 'Test Logo' }
        }
      end

      before do
        mock_settings.each do |key, value|
          allow(guaranteed_settings).to receive(:get).with(key).and_return(OpenStruct.new(value))
        end
      end

      it 'fetches settings as an OpenStruct' do
        settings = instance.all_settings
        expect(settings[:feature]).to be_an(OpenStruct)
      end

      it 'has watermark set to true in settings' do
        settings = instance.all_settings
        expect(settings[:feature].watermark).to eq(true)
      end

      it 'returns the correct setting value' do
        settings = instance.all_settings
        expect(settings[:general].site_name).to eq('Test Blog')
      end

      it 'caches settings' do
        instance.all_settings
        expect(instance.instance_variable_get(:@all_settings)).not_to be_nil
      end
    end

    describe '#get_setting' do
      let(:mock_settings) do
        {
          feature: OpenStruct.new(page_size: 10, comments: false),
          general: OpenStruct.new(blog_title: 'My Blog')
        }
      end

      before do
        allow(instance).to receive(:all_settings).and_return(mock_settings)
      end

      it 'retrieves existing settings for feature.page_size' do
        expect(instance.get_setting('feature.page_size')).to eq(10)
      end

      it 'retrieves existing settings for general.blog_title' do
        expect(instance.get_setting('general.blog_title')).to eq('My Blog')
      end

      it 'returns default value for non-existent settings feature.comments' do
        expect(instance.get_setting('feature.comments')).to eq(false)
      end

      it 'returns default value for completely non-existent settings' do
        default_value = "default_value"
        guaranteed_setting_service = instance_double("BravuraTemplateBase::GuaranteedSettingService")
        allow(BravuraTemplateBase::GuaranteedSettingService).to receive(:new).and_return(guaranteed_setting_service)
        allow(guaranteed_setting_service).to receive(:get).with('non_existent.setting').and_return(default_value)

        expect(instance.get_setting('non_existent.setting')).to eq(default_value)
      end
    end

    describe '#invalidate_settings_cache' do
    let(:settings_service_class) do
      Class.new do
        def self.clear_cache_for_account(account)
        end
      end
    end

    before do
      instance.instance_variable_set(:@all_settings, {})
      stub_const("::SettingsService", settings_service_class)
    end

    it 'clears the cache' do
      expect(mock_cache).to receive(:delete).with("account_settings_1")
      instance.invalidate_settings_cache
    end

    it 'calls clear_cache_for_account on SettingsService' do
      expect(::SettingsService).to receive(:clear_cache_for_account).with(current_account)
      instance.invalidate_settings_cache
    end

    it 'resets all_settings to nil' do
      instance.invalidate_settings_cache
      expect(instance.instance_variable_get(:@all_settings)).to be_nil
    end
  end
  end
end
