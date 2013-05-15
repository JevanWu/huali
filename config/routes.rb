require 'sidekiq/web'

Huali::Application.routes.draw do

  # Mount resque under the admin namespace wardened by devise
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.role == 'super' }
  constraints constraint do
    mount Sidekiq::Web, at: "/admin/sidekiq", as: :sidekiq
  end

  get "areas/:area_id", to: 'areas#show'
  get "cities/:city_id/areas", to: 'areas#index'
  get "cities/:city_id", to: 'cities#show'
  get "provinces/:prov_id/cities", to: 'cities#index'
  get "provinces/:prov_id", to: 'provinces#show'
  get "provinces", to: 'provinces#index'

  resources :products, only: [:show]
  resources :collections, only: [:show]
  resources :reminders, only: [:new, :create]

  # FIXME refactor this routes to be more elegant
  get 'orders/current', as: :current_order
  get 'orders/checkout(/:id)', to: 'orders#checkout', as: :checkout_order
  post 'orders/gateway(/:id)', to: 'orders#gateway', as: :gateway_order
  put 'orders/cancel/:id', to: 'orders#cancel', as: :cancel_order
  get 'orders/return', as: :return_order
  post 'orders/notify', as: :notify_order
  resources :orders, except: [:destroy, :update, :edit]

  # non-individual collections routes
  match '/collections/all', to: 'collections#all'
  match '/collections/:id', to: 'collections#show'

  devise_for :administrators

  devise_for :users

  # oauth
  match '/auth/:oauth_service/callback' => 'oauth_services#create'
  resources :oauth_services, :only => [:index, :create]

  root to: "pages#show", id: 'home'
  get 'partner', to: 'pages#partner', as: :partner
  get 'mother', to: 'pages#mother', as: :mother

  ActiveAdmin.routes(self)

  authenticated :administrators do
    root to: "admin#index"
  end

  get ':id', to: 'pages#show', as: :page
  get "errors/error_404"
  get "errors/error_500"
end
