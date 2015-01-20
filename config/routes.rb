require 'sidekiq/web'
require 'api/api'

Huali::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  # Mount resque under the admin namespace wardened by devise
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.role == 'super' }
  constraints constraint do
    mount Sidekiq::Web, at: "/admin/sidekiq", as: :sidekiq
  end

  get "lucky_draw_offline", to: 'lucky_draw_offlines#new'
  post "lucky_draw_offline", to: 'lucky_draw_offlines#create'


  get "areas/:area_id", to: 'areas#show'
  get "cities/:city_id/areas", to: 'areas#index'
  get "cities/:city_id/areas/available_for_products", to: 'areas#available_for_products'
  get "cities/:city_id", to: 'cities#show'

  get "provinces/:prov_id/cities", to: 'cities#index'
  get "provinces/:prov_id/cities/available_for_products", to: 'cities#available_for_products'
  get "provinces", to: 'provinces#index'
  get "provinces/available_for_products", to: 'provinces#available_for_products'
  get "provinces/:prov_id", to: 'provinces#show'

  post "products/appointment", to: 'products#appointment', as: :appointment
  post "products/greeting_card", to: 'products#greeting_card', as: :greeting_card
  post "products/reply_greeting_card", to: 'products#reply_greeting_card', as: :reply_greeting_card

  get 'search', to: 'products#search'
  resources :products, only: [:show] do
    collection do
      get 'trait/:tags', action: :trait
      get 'discount_events'
    end
  end

  resources :collections, only: [] do
    resources :products, only: [:index], path: '/' do
      get 'tagged_with/:tags', to: 'products#tagged_with', on: :collection
    end
  end

  resources :surveys, only: [:new, :create]
  resources :postcards, only: [:new, :create, :show]

  get 'postcards/:id/question', to: 'postcards#question', as: :postcards_question
  post 'postcards/:id', to: 'postcards#show', as: :postcard_answer

  # FIXME refactor this routes to be more elegant
  get 'orders/current(/:coupon_code/products/:product_ids)', to: 'orders#current', as: :current_order
  post 'orders/wechat_warning', to: 'orders#wechat_warning'
  post 'orders/wechat_feedback', to: 'orders#wechat_feedback'
  post 'orders/apply_coupon'
  get 'orders/checkout(/:id)', to: 'orders#checkout', as: :checkout_order
  post 'orders/gateway(/:id)', to: 'orders#gateway', as: :gateway_order
  patch 'orders/cancel/:id', to: 'orders#cancel', as: :cancel_order
  get 'orders/return', as: :return_order
  post 'orders/paypal_return', as: :return_order_paypal
  match 'orders/notify', as: :notify_order, via: [:get, :post]
  get 'orders/wap_return', as: :wap_return_order
  match 'orders/wap_notify', as: :wap_notify_order, via: [:get, :post]
  post 'orders/wechat_notify'
  get 'orders/:id/gift_card/edit', to: 'orders#edit_gift_card', as: :edit_gift_card
  match 'orders/:id/gift_card/update', to: 'orders#update_gift_card', as: :update_gift_card, via: [:put, :patch]
  get 'orders/instant_delivery_status'

  # quick purchase
  get 'quick_purchases/address/new', to: 'quick_purchases#new_address', as: :new_address_quick_purchase
  post 'quick_purchases/address/create', to: 'quick_purchases#create_address', as: :create_address_quick_purchase

  get 'quick_purchases/products', to: 'quick_purchases#products', as: :products_quick_purchase
  post 'quick_purchases/order/create', to: 'quick_purchases#create_order', as: :create_order_quick_purchase

  # back order urls
  get 'orders/backorder', to: 'orders#back_order_new', as: :new_back_order
  post 'orders/backorder', to: 'orders#back_order_create', as: :create_back_order

  # b2b order urls
  get 'orders/b2border', to: 'orders#b2b_order_new', as: :new_b2b_order
  post 'orders/b2border', to: 'orders#b2b_order_create', as: :create_b2b_order

  # secoo order urls
  get 'orders/secooorder', to: 'orders#secoo_order_new', as: :new_secoo_order
  post 'orders/secooorder', to: 'orders#secoo_order_create', as: :create_secoo_order

  # channel order urls
  #get 'orders/channelorder', to: 'orders#channel_order_new', as: :new_channel_order
  #post 'orders/channelorder', to: 'orders#channel_order_create', as: :create_channel_order

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
  get 'users/profile', to: 'users#profile', as: :profile
  get 'users/new_binding_account', to: 'users#new_binding_account'
  post 'users/binding_account', to: 'users#binding_account'

  get 'settings/profile', to: 'users#edit_profile'
  patch 'settings/profile', to: 'users#update_profile'
  get 'settings/admin', to: 'users#edit_account'
  patch 'account/password', to: 'users#update_password'
  get 'settings/huali_point', to: 'users#huali_point', as: :huali_point
  get 'settings/refer_friend', to: 'users#refer_friend', as: :refer_friend

  match "/contacts/:importer/callback" => "users#omnicontacts_callback", via: [:get, :post]
  match '/contacts/failure', to: 'users#omnicontacts_failure', via: [:get, :post]
  get "/email_contacts/signin", to: "users#email_mimic_signin", as: :email_signin
  post "/email_contacts/import_contacts", to: "users#import_email_contacts", as: :import_contacts

  root to: "pages#home"
  get 'home', to: 'pages#home', as: :home
  get 'partner', to: 'pages#partner', as: :partner
  get 'brands', to: 'pages#brands', as: :brands
  get 'celebrities', to: 'pages#celebrities', as: :celebrities
  get 'medias', to: 'pages#medias', as: :medias
  get 'weibo_stories', to: 'pages#weibo_stories', as: :weibo_stories
  get 'christmas', to: 'pages#christmas', as: :christmas
  get 'valentine', to: 'pages#valentine', as: :valentine
  get 'valentine_2015', to: 'pages#valentine_2015'
  get 'white_day', to: 'pages#white_day', as: :white_day
  get 'pick_up', to: 'pages#pick_up', as: :pick_up
  get 'muqinjie', to: 'pages#mother_day', as: :muqinjie
  get 'qixijie', to: 'pages#qixijie', as: :qixijie
  get 'join_us', to: 'pages#join_us'
  get 'yujianli', to: 'pages#yujianli'
  get 'offline_shop', to: 'pages#offline_shop'
  get 'perfume', to: 'pages#perfume'
  get 'movie', to: 'pages#movie'

  get 'banners/:date', to: 'banners#index', as: :banners
  get 'stories', to: 'stories#index'
  resources :didi_passengers, only: [:new, :create], path: 'diditaxi'

  get 'wechats/pay', to: 'wechats#pay', as: :wechats_pay
  API::API.logger Rails.logger
  mount API::API => '/api'
  mount MobileAPI::API => '/mobile_api'

  ActiveAdmin.routes(self)

  get ':id', to: 'pages#show', id: /(?!(news|business|blog))(.+)/, as: :page
end
