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
          allow(guaranteed_settings).to receive(:get).with(key).and_return(value)
        end
      end

      it 'fetches settings as a Hash' do
        expect(instance.all_settings[:feature]).to be_a(Hash)
      end

      it 'includes watermark setting' do
        expect(instance.all_settings[:feature][:watermark]).to eq(true)
      end

      it 'includes site_name setting' do
        expect(instance.all_settings[:general][:site_name]).to eq('Test Blog')
      end

      it 'caches settings' do
        instance.all_settings
        expect(instance.instance_variable_get(:@all_settings)).not_to be_nil
      end
    end

    describe '#get_setting' do
      it 'retrieves page_size setting' do
        expect(guaranteed_settings).to receive(:get).with('feature.page_size').and_return(10)
        expect(instance.get_setting('feature.page_size')).to eq(10)
      end

      it 'retrieves blog_title setting' do
        expect(guaranteed_settings).to receive(:get).with('general.blog_title').and_return('My Blog')
        expect(instance.get_setting('general.blog_title')).to eq('My Blog')
      end

      it 'returns default value for non-existent settings' do
        expect(guaranteed_settings).to receive(:get).with('non_existent.setting').and_return('N/A')
        expect(instance.get_setting('non_existent.setting')).to eq('N/A')
      end
    end

    describe '#invalidate_settings_cache' do
      before do
        instance.instance_variable_set(:@all_settings, {})
        instance.instance_variable_set(:@guaranteed_setting_service, guaranteed_settings)
      end

      it 'clears the cache' do
        expect(mock_cache).to receive(:delete).with("account_settings_1")
        instance.invalidate_settings_cache
      end

      it 'resets all_settings to nil' do
        instance.invalidate_settings_cache
        expect(instance.instance_variable_get(:@all_settings)).to be_nil
      end

      it 'resets guaranteed_setting_service to nil' do
        instance.invalidate_settings_cache
        expect(instance.instance_variable_get(:@guaranteed_setting_service)).to be_nil
      end
    end
  end
end
