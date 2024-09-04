require 'spec_helper'
require 'bravura_template_base/default_settings_repository'

module BravuraTemplateBase
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

    describe '#default_image_path' do
      it 'returns the correct default image path for existing images' do
        expect(repository.default_image_path('general', 'social_cover')).to eq('path/to/default/social_cover.jpg')
      end

      it 'returns nil for non-existent images' do
        expect(repository.default_image_path('general', 'non_existent_image')).to be_nil
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
