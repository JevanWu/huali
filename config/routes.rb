Huali::Application.routes.draw do

  # Mount resque under the admin namespace wardened by devise
  require 'resque/server'
  resque_constraint = lambda do |request|
    request.env['warden'].authenticate!({ :scope => :administrator })
  end
  constraints resque_constraint do
    mount Resque::Server.new, :at => "/admin/resque", as: 'resque'
  end

  get "areas/:area_id", :to => 'areas#show'
  get "cities/:city_id/areas", :to => 'areas#index'
  get "cities/:city_id", :to => 'cities#show'
  get "provinces/:prov_id/cities", :to => 'cities#index'
  get "provinces/:prov_id", :to => 'provinces#show'
  get "provinces", :to => 'provinces#index'

  resources :products, :only => [:show]
  resources :collections, :only => [:show]

  # FIXME refactor this routes to be more elegant
  get 'orders/current', as: :current_order
  get 'orders/checkout(/:id)', to: 'orders#checkout', as: :checkout_order
  post 'orders/gateway(/:id)', to: 'orders#gateway', as: :gateway_order
  put 'orders/cancel/:id', to: 'orders#cancel', as: :cancel_order
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

  get ':id', to: 'pages#show', as: :page
  get "errors/error_404"
  get "errors/error_500"
end
