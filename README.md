# BravuraTemplateBase
What the `bravura_template_base` gem does:

1. Template Management:
   - The gem provides a system for managing and loading different blog templates.
   - It defines a set of available templates and a default template.

2. Dynamic Template Loading:
   - The `load_template` method dynamically loads a template based on the account's settings.
   - It handles the loading of template-specific assets (JavaScript and CSS) into the Rails asset pipeline.

3. Fallback Mechanism:
   - If a specified template doesn't exist, it falls back to the default template.
   - It logs a warning when falling back to the default template.

4. Error Handling:
   - It raises an error if the default template is not found.
   - It validates that the account object has the necessary attributes.

5. Flexible Configuration:
   - The gem allows for different templates to be defined and used without modifying the main application code.

6. Asset Management:
   - It adds template-specific asset paths to the Rails asset pipeline.
   - It adds template-specific CSS to the precompile list.

In essence, this gem serves as a foundation for a multi-template blog system. It allows different accounts to use different blog templates, all managed through a central system. The main benefits are:

1. Modularity: Templates can be developed and managed separately from the main application.
2. Flexibility: Accounts can easily switch between different templates.
3. Consistency: It provides a standard way to handle different blog templates across the application.
4. Error Handling: It gracefully handles cases where a template might be missing or incorrectly specified.

The gem is designed to work within a larger Rails application, where it can be used to dynamically load and manage different blog templates based on account settings. It's a key component in creating a flexible, multi-tenant blogging platform where different users or accounts can have different looking blogs all running on the same underlying system.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "bravura_template_base"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install bravura_template_base
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
