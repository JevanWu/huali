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

  root :to => "pages#home", :as => :home

  ActiveAdmin.routes(self)

  authenticated :administrators do
    root :to => "admin#index"
  end

  get 'order/:name_en', to: 'pages#order', as: :order
  get 'payment/:name_en', to: 'pages#payment', as: :payment
  post 'payment/:name_en', to: 'pages#gateway', as: :gateway

  # alipay related url
  get 'success/:name_en', to: 'pages#return', as: :success
  post '/notify', to: 'pages#notify', as: :notify
  post '/notify_error', to: 'pages#notify_error', as: :notify_error

  get ':id', to: 'pages#show', as: :page
  get "errors/error_404"
  get "errors/error_500"

end
