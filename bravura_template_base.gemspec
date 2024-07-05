require_relative "lib/bravura_template_base/version"

Gem::Specification.new do |spec|
  spec.name        = "bravura_template_base"
  spec.version     = BravuraTemplateBase::VERSION
  spec.authors     = ["Carl Tanner"]
  spec.email       = ["carl@wdwhub.net"]
  spec.homepage    = "https://github.com/yourusername/bravura_template_base"
  spec.summary     = "Base gem for Bravura blog templates"
  spec.description = "Provides a foundation for creating and managing blog templates in the Bravura platform"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/bravura_template_base"
  spec.metadata["changelog_uri"] = "https://github.com/yourusername/bravura_template_base/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.0"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "faker"
end
