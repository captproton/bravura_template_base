# spec/lib/bravura_template_base/settings_integration_spec.rb
require 'spec_helper'
require 'active_support/all'
require 'bravura_template_base/settings_integration'
require 'bravura_template_base/null_settings'

RSpec.describe BravuraTemplateBase::SettingsIntegration do
  let(:dummy_class) do
    Class.new do
      def self.helper_method(*); end
      include BravuraTemplateBase::SettingsIntegration
      attr_accessor :current_account
    end
  end

  let(:instance) { dummy_class.new }
  let(:current_account) { double('Account', id: 1) }
  let(:settings_service) { class_double('SettingsService') }
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
  let(:mock_cache) { ActiveSupport::Cache::MemoryStore.new }

  before do
    stub_const('SettingsService', settings_service)
    allow(settings_service).to receive(:for_account).and_return(mock_settings)
    allow(settings_service).to receive(:clear_cache_for_account)

    dummy_class.cache_store = mock_cache
    instance.current_account = current_account
  end

  describe '#all_settings' do
    it 'fetches settings from cache when available' do
      expect(mock_cache).to receive(:fetch).with("account_settings_1", expires_in: 1.hour).and_call_original
      instance.all_settings
    end

    it 'fetches settings directly from SettingsService when cache is empty' do
      expect(settings_service).to receive(:for_account).with(current_account)
      instance.all_settings
    end

    context 'when all settings are present' do
      it 'returns the correct feature settings' do
        expect(instance.all_settings[:feature].watermark).to eq(true)
      end

      it 'returns the correct general settings' do
        expect(instance.all_settings[:general].site_name).to eq('Test Blog')
      end

      it 'returns the correct design settings' do
        expect(instance.all_settings[:design].font_family).to eq('Arial')
      end

      it 'returns the correct cta_button_setup settings' do
        expect(instance.all_settings[:cta_button_setup].show_cta_button).to eq(true)
      end

      it 'returns the correct email_newsletter_setup settings' do
        expect(instance.all_settings[:email_newsletter_setup].header_enabled).to eq(false)
      end

      it 'returns the correct footer settings' do
        expect(instance.all_settings[:footer].footer_description).to eq('Test Footer')
      end

      it 'returns the correct navigation settings' do
        expect(instance.all_settings[:navigation].logo_text).to eq('Test Logo')
      end
    end

    context 'when settings are missing' do
      let(:mock_settings) { {} }

      it 'returns a null object for feature settings' do
        expect(instance.all_settings[:feature]).to be_a(BravuraTemplateBase::NullSettings::NullFeature)
      end

      it 'returns a null object for general settings' do
        expect(instance.all_settings[:general]).to be_a(BravuraTemplateBase::NullSettings::NullGeneral)
      end

      it 'returns a null object for design settings' do
        expect(instance.all_settings[:design]).to be_a(BravuraTemplateBase::NullSettings::NullDesign)
      end

      it 'returns a null object for cta_button_setup settings' do
        expect(instance.all_settings[:cta_button_setup]).to be_a(BravuraTemplateBase::NullSettings::NullCtaButtonSetup)
      end

      it 'returns a null object for email_newsletter_setup settings' do
        expect(instance.all_settings[:email_newsletter_setup]).to be_a(BravuraTemplateBase::NullSettings::NullEmailNewsletterSetup)
      end

      it 'returns a null object for footer settings' do
        expect(instance.all_settings[:footer]).to be_a(BravuraTemplateBase::NullSettings::NullFooter)
      end

      it 'returns a null object for navigation settings' do
        expect(instance.all_settings[:navigation]).to be_a(BravuraTemplateBase::NullSettings::NullNavigation)
      end

      it 'null feature object returns default watermark value' do
        expect(instance.all_settings[:feature].watermark).to eq(true)
      end

      it 'null general object returns default html_lang value' do
        expect(instance.all_settings[:general].html_lang).to eq("en")
      end

      it 'null design object returns default font_family value' do
        expect(instance.all_settings[:design].font_family).to eq("Default")
      end

      it 'null cta_button_setup object returns default show_cta_button value' do
        expect(instance.all_settings[:cta_button_setup].show_cta_button).to eq(true)
      end

      it 'null email_newsletter_setup object returns default header_enabled value' do
        expect(instance.all_settings[:email_newsletter_setup].header_enabled).to eq(false)
      end

      it 'null footer object returns default footer_description value' do
        expect(instance.all_settings[:footer].footer_description).to eq("Default Footer Description")
      end

      it 'null navigation object returns default logo_text value' do
        expect(instance.all_settings[:navigation].logo_text).to eq("Default Logo Text")
      end
    end
  end

  describe '#get_setting' do
    it 'retrieves nested general.site_name setting correctly' do
      expect(instance.get_setting('general.site_name')).to eq('Test Blog')
    end

    it 'retrieves nested design.font_family setting correctly' do
      expect(instance.get_setting('design.font_family')).to eq('Arial')
    end

    context 'when settings are missing' do
      let(:mock_settings) { {} }

      it 'returns default value for non-existent general.site_name setting' do
        expect(instance.get_setting('general.publication_name')).to eq("Default Publication name")
      end

      it 'returns default value for non-existent design.font_family setting' do
        expect(instance.get_setting('design.font_family')).to eq("Default")
      end

      it 'returns default value for non-existent feature.watermark setting' do
        expect(instance.get_setting('feature.watermark')).to eq(true)
      end

      it 'returns default value for non-existent cta_button_setup.show_cta_button setting' do
        expect(instance.get_setting('cta_button_setup.show_cta_button')).to eq(true)
      end

      it 'returns default value for non-existent email_newsletter_setup.header_enabled setting' do
        expect(instance.get_setting('email_newsletter_setup.header_enabled')).to eq(false)
      end

      it 'returns default value for non-existent footer.footer_description setting' do
        expect(instance.get_setting('footer.footer_description')).to eq("Default Footer Description")
      end

      it 'returns default value for non-existent navigation.logo_text setting' do
        expect(instance.get_setting('navigation.logo_text')).to eq("Default Logo Text")
      end
    end
  end

  describe '#invalidate_settings_cache' do
    it 'deletes the cache for the current account' do
      expect(mock_cache).to receive(:delete).with("account_settings_1")
      instance.invalidate_settings_cache
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
