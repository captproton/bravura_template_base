# app/presenters/bravura_template_base/base_presenter.rb
module BravuraTemplateBase
  class BasePresenter
    def initialize(settings)
      @settings = settings
    end

    def site_name
      @settings.get("site_name")
    end

    def page_title
      site_name
    end

    def main_content_class
      "base-main-content"
    end

    def header_title
      site_name
    end

    def footer_text
      "© #{Time.current.year} #{site_name}"
    end

    # Add more common presenter methods as needed
  end
end
