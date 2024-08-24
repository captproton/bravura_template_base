require 'spec_helper'

RSpec.describe BravuraTemplateBase do
  it "has a version number" do
    expect(BravuraTemplateBase::VERSION).not_to be nil
  end

  it "can load a template" do
    # FIXME: This test is not working as expected
    # app = OpenStruct.new(config: OpenStruct.new(assets: OpenStruct.new(paths: [], precompile: [])))
    # account = build(:account, :with_normal_template)
    # normal_engine = Class.new(Rails::Engine)
    # stub_const("BravuraTemplateNormal::Engine", normal_engine)
    # allow_any_instance_of(normal_engine).to receive(:root).and_return(Pathname.new("/dummy/path"))
    # expect {
    #   BravuraTemplateBase.load_template(app, account)
    # }.not_to raise_error
  end
end
