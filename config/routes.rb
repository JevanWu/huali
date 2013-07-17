require 'sidekiq/web'

Huali::Application.routes.draw do

  # Mount resque under the admin namespace wardened by devise
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.role == 'super' }
  constraints constraint do
    mount Sidekiq::Web, at: "/admin/sidekiq", as: :sidekiq
  end

  get "areas/:area_id", to: 'areas#show'
  get "cities/:city_id/areas", to: 'areas#index'
  get "cities/:city_id/areas/available_for_products", to: 'areas#available_for_products'
  get "cities/:city_id", to: 'cities#show'

  get "provinces/:prov_id/cities", to: 'cities#index'
  get "provinces/:prov_id/cities/available_for_products", to: 'cities#available_for_products'
  get "provinces", to: 'provinces#index'
  get "provinces/available_for_products", to: 'provinces#available_for_products'
  get "provinces/:prov_id", to: 'provinces#show'

  resources :products, only: [:show]
  resources :collections, only: [:show]
  resources :reminders, only: [:new, :create]
  resources :surveys, only: [:new, :create]

  # FIXME refactor this routes to be more elegant
  get 'orders/current', as: :current_order
  get 'orders/checkout(/:id)', to: 'orders#checkout', as: :checkout_order
  post 'orders/gateway(/:id)', to: 'orders#gateway', as: :gateway_order
  put 'orders/cancel/:id', to: 'orders#cancel', as: :cancel_order
  get 'orders/return', as: :return_order
  post 'orders/notify', as: :notify_order
  # back order urls
  get 'orders/backorder', to: 'orders#back_order_new', as: :new_back_order
  post 'orders/backorder', to: 'orders#back_order_create', as: :create_back_order
  # taobao order urls
  get 'orders/taobaoorder', to: 'orders#taobao_order_new', as: :new_taobao_order
  post 'orders/taobaoorder', to: 'orders#taobao_order_create', as: :create_taobao_order
  resources :orders, except: [:destroy, :update, :edit]

  post 'shipments/notify/:identifier', to: 'shipments#notify', as: :notify_shipment

  # non-individual collections routes
  match '/collections/:id', to: 'collections#show'

  devise_for :administrators

  # FIXME need to know exact behaviors of controllers params
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_services' } do
    get '/users/bind_with_oauth' => 'oauth_registrations#new_from_oauth', as: :new_oauth_user_registration
    post '/users/bind_with_oauth' => 'oauth_registrations#bind_with_oauth'
  end

  get 'users/check_user_exist', to: 'users#check_user_exist'

  root to: "pages#show", id: 'home'
  get 'partner', to: 'pages#partner', as: :partner

  ActiveAdmin.routes(self)

  authenticated :administrators do
    root to: "admin#index"
  end

  get ':id', to: 'pages#show', as: :page
  get "errors/error_404"
  get "errors/error_500"
end
