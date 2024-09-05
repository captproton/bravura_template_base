# spec/presenters/bravura_template_base/base_presenter_spec.rb

require 'rails_helper'

RSpec.describe BravuraTemplateBase::BasePresenter do
  let(:settings) { instance_double("BravuraTemplateBase::GuaranteedSettingService") }
  let(:presenter) { described_class.new(settings) }

  describe "#get" do
    context "with a regular value" do
      it "returns the value from settings" do
        allow(settings).to receive(:get).with("some.key").and_return("some value")
        expect(presenter.get("some.key")).to eq("some value")
      end
    end

    context "with an ActiveStorage attachment" do
      let(:attachment) { instance_double("ActiveStorage::Attached::One") }

      it "returns the attachment if it's attached" do
        allow(settings).to receive(:get).with("image.key").and_return(attachment)
        allow(attachment).to receive(:is_a?).with(ActiveStorage::Attached::One).and_return(true)
        allow(attachment).to receive(:attached?).and_return(true)
        expect(presenter.get("image.key")).to eq(attachment)
      end

      it "returns the default image path if the attachment is not attached" do
        allow(settings).to receive(:get).with("image.key").and_return(attachment)
        allow(attachment).to receive(:is_a?).with(ActiveStorage::Attached::One).and_return(true)
        allow(attachment).to receive(:attached?).and_return(false)
        allow_any_instance_of(BravuraTemplateBase::DefaultSettingsRepository).to receive(:default_image_path).and_return("/default/image.jpg")
        expect(presenter.get("image.key")).to eq("/default/image.jpg")
      end
    end
  end

  describe "#image_path" do
    it "returns the URL for an ActiveStorage attachment" do
      attachment = double("ActiveStorage::Attached::One")
      allow(attachment).to receive(:url).and_return("/path/to/image.jpg")
      allow(presenter).to receive(:get).with("image.key").and_return(attachment)
      allow(attachment).to receive(:respond_to?).with(:url).and_return(true)
      expect(presenter.image_path("image.key")).to eq("/path/to/image.jpg")
    end

    it "returns the string value for a regular path" do
      allow(presenter).to receive(:get).with("image.key").and_return("/static/image.jpg")
      expect(presenter.image_path("image.key")).to eq("/static/image.jpg")
    end
  end

  describe "#responsive_image_attributes" do
    context "with an ActiveStorage attachment" do
      let(:attachment) { double("ActiveStorage::Attached::One") }
      let(:variant) { double("ActiveStorage::Variant") }

      before do
        allow(presenter).to receive(:get).with("image.key").and_return(attachment)
        allow(attachment).to receive(:respond_to?).with(:variant).and_return(true)
        allow(attachment).to receive(:variant).and_return(variant)
        allow(variant).to receive(:processed).and_return(variant)
        allow(variant).to receive(:url).and_return("/path/to/image.jpg")
      end

      it "returns responsive image attributes" do
        result = presenter.responsive_image_attributes("image.key")
        expect(result[:src]).to eq("/path/to/image.jpg")
        expect(result[:srcset]).to include("300w", "600w", "900w", "1200w")
        expect(result[:sizes]).to eq("100vw")
      end

      it "allows custom widths and sizes" do
        result = presenter.responsive_image_attributes("image.key", sizes: "(max-width: 600px) 100vw, 50vw", widths: [ 400, 800 ])
        expect(result[:srcset]).to include("400w", "800w")
        expect(result[:sizes]).to eq("(max-width: 600px) 100vw, 50vw")
      end
    end
    context "with a regular string path" do
      it "returns a simple src attribute" do
        allow(presenter).to receive(:get).with("image.key").and_return("/static/image.jpg")
        result = presenter.responsive_image_attributes("image.key")
        expect(result).to eq({ src: "/static/image.jpg" })
      end
    end
  end
end
