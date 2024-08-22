# lib/bravura_template_base/app/controllers/bravura_template_base/blog_controller.rb
module BravuraTemplateBase
  class BlogController < ApplicationController
    include BravuraTemplateBase::BlogControllerConcern

    def index
      super
      render template: 'bravura_template_base/blog/index'
    end

    def show
      super
      render template: 'bravura_template_base/blog/show'
    end
  end
end
