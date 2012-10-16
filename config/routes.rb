Changanhua::Application.routes.draw do

  get "errors/error_404"

  get "errors/error_500"

  ActiveAdmin.routes(self)
  
  resources :products, :only => [:show, :index]

  # non-individual collections routes
  match '/collections/all', :to => 'collections#all'
  resources :collections, :only => [:show, :index]

  devise_for :administrators

  authenticated :administrators do
    root :to => "admin#index"
  end

  root :to => "home#index"
  
  get 'order', to: 'pages#order', as: :page
  get ':id', to: 'pages#show', as: :page
 

end
