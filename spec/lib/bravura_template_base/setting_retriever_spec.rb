# spec/lib/bravura_template_base/setting_retriever_spec.rb

require 'spec_helper'
require 'bravura_template_base/setting_retriever'

# Mock ActiveStorage if it's not available in the test environment
unless defined?(ActiveStorage)
  module ActiveStorage
    module Attached
      class One
        def attached?; end
      end
      class Many
        def attached?; end
      end
    end
  end
end

module BravuraTemplateBase
  RSpec.describe SettingRetriever do
    let(:settings_service) { double("SettingsService") }
    let(:default_settings) { instance_double("BravuraTemplateBase::DefaultSettingsRepository") }
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
          expect(result).to eq(false)
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

      context 'when dealing with ActiveStorage attachments' do
        let(:attachment) { instance_double(ActiveStorage::Attached::One, attached?: true) }

        it 'handles ActiveStorage attachments correctly' do
          allow(settings_service).to receive(:[]).with(:general).and_return(double(logo: attachment))
          expect(retriever.get('general.logo')).to eq(attachment)
        end

        it 'returns default image path when attachment is not attached' do
          unattached_attachment = instance_double(ActiveStorage::Attached::One, attached?: false)
          allow(settings_service).to receive(:[]).with(:general).and_return(double(logo: unattached_attachment))
          allow(default_settings).to receive(:default_image_path).with('general', 'logo').and_return('path/to/default/logo.png')
          expect(retriever.get('general.logo')).to eq('path/to/default/logo.png')
        end
      end
    end
  end
end
