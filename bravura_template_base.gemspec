require_relative "lib/bravura_template_base/version"

Gem::Specification.new do |spec|
  spec.name        = "bravura_template_base"
  spec.version     = BravuraTemplateBase::VERSION
  spec.authors     = [ "Carl Tanner" ]
  spec.email       = [ "carl@wdwhub.net" ]
  spec.homepage    = "https://github.com/yourusername/bravura_template_base"
  spec.summary     = "Base gem for Bravura blog templates"
  spec.description = "This gem is designed to work within a larger Rails application, where it can be used to dynamically load and manage different blog templates based on account settings. It's a key component in creating a flexible, multi-tenant blogging platform where different users or accounts can have different looking blogs all running on the same underlying system."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/bravura_template_base"
  spec.metadata["changelog_uri"] = "https://github.com/yourusername/bravura_template_base/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.4"
  spec.add_dependency "pagy", "~> 9.0"

  spec.add_development_dependency "rspec-rails", '~> 6.1', '>= 6.1.3'
  spec.add_development_dependency "factory_bot_rails", '~> 6.4', '>= 6.4.3'
  spec.add_development_dependency "faker", '~> 3.4', '>= 3.4.1'
end
