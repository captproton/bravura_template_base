require 'ostruct'

class Account < OpenStruct
  def initialize(attributes = nil)
    super(attributes || {})
    self.settings ||= OpenStruct.new(design: Settings::Design.new)
  end

  def settings_design
    settings.design
  end
end

module Settings
  class Design < OpenStruct
    def initialize(attributes = nil)
      super(attributes || {})
      self.blog_template_gem ||= 'default_template'
    end
  end
end
class Post
  def self.published
    []
  end

  def self.featured
    []
  end

  def self.recently_published
    []
  end

  def self.find(id)
    new
  end

  def related_posts
    []
  end
end
