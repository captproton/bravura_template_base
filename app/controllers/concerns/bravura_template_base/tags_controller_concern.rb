# app/controllers/concerns/bravura_template_base/tags_controller_concern.rb
module BravuraTemplateBase
  module TagsControllerConcern
    extend ActiveSupport::Concern
    include BravuraTemplateBase::BaseControllerConcern

    def index
      load_tags_data
      render_with_strategy :index
    end

    def show
      load_tag_data
      render_with_strategy :show
    rescue ActiveRecord::RecordNotFound
      render_not_found
    end

    private

    def load_tags_data
      # Override this method in the main controller to load tags data
    end

    def load_tag_data
      # Override this method in the main controller to load specific tag data
    end
  end
end
