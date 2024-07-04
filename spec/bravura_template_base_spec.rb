require 'spec_helper'

RSpec.describe BravuraTemplateBase do
  it "has a version number" do
    expect(BravuraTemplateBase::VERSION).not_to be nil
  end

  it "can load a template" do
    app = build(:app)

    # Mock the engine constant
    normal_engine = Class.new(Rails::Engine)
    stub_const("BravuraTemplate::Normal::Engine", normal_engine)
    allow_any_instance_of(normal_engine).to receive(:root).and_return(Pathname.new("/dummy/path"))

    expect {
      BravuraTemplateBase.load_template(app, 'normal')
    }.not_to raise_error
  end
end
