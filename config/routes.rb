Huali::Application.routes.draw do
  resources :products, :only => [:show]
  resources :collections, :only => [:show]

  # FIXME refactor this routes to be more elegant
  get 'orders/current', as: :current_order
  get 'orders/checkout', as: :checkout_order
  post 'orders/gateway', as: :gateway_order
  get 'orders/return', as: :return_order
  post 'orders/notify', as: :notify_order
  resources :orders, :except => [:destroy, :update, :edit]

  # non-individual collections routes
  match '/collections/all', :to => 'collections#all'
  match '/collections/:id', :to => 'collections#show'

  devise_for :administrators

  devise_for :users

  root :to => "pages#home"

  ActiveAdmin.routes(self)

  authenticated :administrators do
    root :to => "admin#index"
  end

  get 'share/:name_en', to: 'pages#share', as: :share

  get ':id', to: 'pages#show', as: :page
  get "errors/error_404"
  get "errors/error_500"
end
