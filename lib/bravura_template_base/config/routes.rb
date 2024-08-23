# lib/bravura_template_base/config/routes.rb
BravuraTemplateBase::Engine.routes.draw do
  root "blog#index"

  get "/blog", to: "blog#index", as: :blog_index
  get "/blog/:id", to: "blog#show", as: :blog_show
end
