# app/controllers/concerns/bravura_template_base/authors_controller_concern.rb
module BravuraTemplateBase
  module AuthorsControllerConcern
    extend ActiveSupport::Concern
    include BravuraTemplateBase::BaseControllerConcern

    def index
      load_authors_data
      render_with_strategy :index
    end

    def show
      load_author_data
      render_with_strategy :show
    rescue ActiveRecord::RecordNotFound
      render_not_found
    end

    private

    def load_authors_data
      # Override this method in the main controller to load authors data
    end

    def load_author_data
      # Override this method in the main controller to load specific author data
    end
  end
end
