require 'sidekiq/web'
require 'api/api'

Huali::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
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

  get 'search', to: 'products#search'
  resources :products, only: [:show] do
    collection do
      get 'trait/:tags', action: :trait
    end
  end

  resources :collections, only: [] do
    resources :products, only: [:index], path: '/' do
      get 'tagged_with/:tags', to: 'products#tagged_with', on: :collection
    end
  end

  resources :surveys, only: [:new, :create]

  # FIXME refactor this routes to be more elegant
  get 'orders/current(/:coupon_code/products/:product_ids)', to: 'orders#current', as: :current_order
  post 'orders/apply_coupon'
  get 'orders/checkout(/:id)', to: 'orders#checkout', as: :checkout_order
  post 'orders/gateway(/:id)', to: 'orders#gateway', as: :gateway_order
  patch 'orders/cancel/:id', to: 'orders#cancel', as: :cancel_order
  get 'orders/return', as: :return_order
  match 'orders/notify', as: :notify_order, via: [:get, :post]
  # back order urls
  get 'orders/backorder', to: 'orders#back_order_new', as: :new_back_order
  post 'orders/backorder', to: 'orders#back_order_create', as: :create_back_order
  # channel order urls
  get 'orders/channelorder', to: 'orders#channel_order_new', as: :new_channel_order
  post 'orders/channelorder', to: 'orders#channel_order_create', as: :create_channel_order
  resources :orders, except: [:destroy, :update, :edit] do
    get 'logistics', on: :member
  end

  post 'shipments/notify/:identifier', to: 'shipments#notify', as: :notify_shipment
  post 'shipments/confirm/:id', to: 'shipments#confirm', as: :confirm_shipment

  devise_for :administrators

  # FIXME need to know exact behaviors of controllers params
  devise_for :users, controllers: { invitations: 'invitations', omniauth_callbacks: 'oauth_services' }

  devise_scope :user do
    get '/users/bind_with_oauth', to: 'oauth_registrations#new_from_oauth', as: :new_oauth_user_registration
    post '/users/bind_with_oauth', to: 'oauth_registrations#bind_with_oauth'
  end

  get 'users/check_user_exist', to: 'users#check_user_exist'
  post 'users/subscribe_email', to: 'users#subscribe_email'

  get 'settings/profile', to: 'users#edit_profile'
  put 'settings/profile', to: 'users#update_profile'
  get 'settings/admin', to: 'users#edit_account'
  put 'account/password', to: 'users#update_password'
  get 'settings/huali_point', to: 'users#huali_point', as: :huali_point

  root to: "pages#home"
  get 'home', to: 'pages#home', as: :home
  get 'partner', to: 'pages#partner', as: :partner
  get 'brands', to: 'pages#brands', as: :brands
  get 'celebrities', to: 'pages#celebrities', as: :celebrities
  get 'medias', to: 'pages#medias', as: :medias
  get 'weibo_stories', to: 'pages#weibo_stories', as: :weibo_stories
  get 'christmas', to: 'pages#christmas', as: :christmas
  get 'valentine', to: 'pages#valentine', as: :valentine
  get 'white_day', to: 'pages#white_day', as: :white_day
  get 'pick_up', to: 'pages#pick_up', as: :pick_up
  get 'muqinjie', to: 'pages#mother_day', as: :muqinjie
  get 'refer_friend', to: 'pages#refer_friend', as: :refer_friend
  get '/contacts/failure', to: 'pages#failure'
  get '/contact_callback', to: 'pages#contact_callback'

  get 'banners/:date', to: 'banners#index', as: :banners
  get 'stories', to: 'stories#index'
  resources :didi_passengers, only: [:new, :create], path: 'diditaxi'

  API::API.logger Rails.logger
  mount API::API => '/api'

  ActiveAdmin.routes(self)

  get ':id', to: 'pages#show', id: /(?!blog)(.+)/, as: :page
end
