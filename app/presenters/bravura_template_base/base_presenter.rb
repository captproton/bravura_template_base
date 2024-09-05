# app/presenters/bravura_template_base/base_presenter.rb
# see below for usage
# This is a presenter class that is used to encapsulate the logic for retrieving and presenting settings from the settings service.
# The presenter class is used in the controller to retrieve settings and pass them to the
# view. The presenter class is also used in the view to retrieve settings and present them to the user.
module BravuraTemplateBase
  class BasePresenter
    def initialize(settings)
      @settings = settings
    end

    def get(key)
      value = @settings.get(key)
      if value.is_a?(ActiveStorage::Attached::One)
        value.attached? ? value : default_image_path(key)
      else
        value
      end
    end

    def image_path(key)
      value = get(key)
      value.respond_to?(:url) ? value.url : value.to_s
    end

    def responsive_image_attributes(key, sizes: nil, widths: [300, 600, 900, 1200])
      value = get(key)
      if value.respond_to?(:variant)
        {
          src: value.variant(resize_to_limit: [widths.max, nil]).processed.url,
          srcset: generate_srcset(value, widths),
          sizes: sizes || "100vw"
        }
      else
        { src: value.to_s }
      end
    end

    private

    def default_image_path(key)
      BravuraTemplateBase::DefaultSettingsRepository.new.default_image_path(*key.split('.'))
    end

    def generate_srcset(attachment, widths)
      widths.map do |size|
        "#{attachment.variant(resize_to_limit: [size, nil]).processed.url} #{size}w"
      end.join(', ')
    end
  end
end
# This updated BasePresenter includes the following features:

# * get(key): Retrieves a setting value, handling both ActiveStorage attachments and regular values.
# * image_path(key): Returns a usable path for an image, whether it's an ActiveStorage attachment or a default image path.
# * responsive_image_attributes(key, sizes: nil, widths: [300, 600, 900, 1200]):

# Generates attributes for responsive images, including src, srcset, and sizes.
# Allows customization of image widths for the srcset.
# Handles both ActiveStorage attachments and default image paths.


# default_image_path(key): A private method to fetch the default image path from the DefaultSettingsRepository.
# generate_srcset(attachment, widths): A private method to generate the srcset string for responsive images.

# This implementation provides a flexible and robust way to handle various image scenarios in your templates. You can use it in your views like this:
# For a simple image:

# <%= image_tag(@presenter.image_path("general.social_cover"), alt: "Social Cover Image") %>

# For a responsive image:

# <% image_attrs = @presenter.responsive_image_attributes("general.social_cover",
#                                                         sizes: "(max-width: 600px) 100vw, 50vw",
#                                                         widths: [400, 800, 1200, 1600]) %>
# <%= image_tag(image_attrs[:src],
#               srcset: image_attrs[:srcset],
#               sizes: image_attrs[:sizes],
#               alt: "Social Cover Image",
#               loading: "lazy") %>

# This setup allows for easy extension in template-specific presenters and provides a consistent
# interface for handling images across different templates in your BravuraTemplateBase
# system.
