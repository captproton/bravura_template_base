BravuraTemplateBase::Engine.routes.draw do
  resources :blog, only: %i[index show]
end
