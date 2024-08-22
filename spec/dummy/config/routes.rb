Rails.application.routes.draw do
  mount BravuraTemplateBase::Engine => "/bravura_template_base"

  resources :blog, only: [:index, :show]
end
