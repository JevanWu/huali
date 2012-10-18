Changanhua::Application.routes.draw do

  ActiveAdmin.routes(self)

  match '/products/:id', :to => 'products#show'

  # non-individual collections routes
  match '/collections/all', :to => 'collections#all'
  match '/collections/:id', :to => 'collections#show'

  devise_for :administrators

  authenticated :administrators do
    root :to => "admin#index"
  end

  root :to => "home#index"

  get 'order', to: 'pages#order', as: :page
  get ':id', to: 'pages#show', as: :page
  get "errors/error_404"
  get "errors/error_500"

end
