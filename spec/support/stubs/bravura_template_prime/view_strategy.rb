# spec/support/stubs/bravura_template_prime/view_strategy.rb

module BravuraTemplatePrime
  class ViewStrategy
    def initialize(settings:, **options)
    end

    def template_for(action)
      "bravura_template_prime/#{action}"
    end

    def layout
      'bravura_template_prime/application'
    end
  end
end
