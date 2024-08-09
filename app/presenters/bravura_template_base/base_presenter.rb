# app/presenters/bravura_template_base/base_presenter.rb
module BravuraTemplateBase
  class BasePresenter
    def initialize(settings)
      @settings = settings
    end

    def get(key)
      @settings.get(key)
    end

    # Other methods...
  end
end
