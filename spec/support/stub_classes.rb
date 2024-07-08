class Account < OpenStruct
  def initialize(attributes = nil)
    super
    self.settings = OpenStruct.new(design: Settings::Design.new)
  end
end

module Settings
  class Design < OpenStruct
  end
end
