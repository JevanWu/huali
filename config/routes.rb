Huali::Application.routes.draw do

  resources :products, :only => [:show]
  resources :collections, :only => [:show]
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
  get 'share/:name_en', to: 'pages#share', as: :share
  post 'payment/:name_en', to: 'pages#gateway', as: :gateway
  get 'partner', to: 'pages#partner', as: :partner

  # alipay related url
  get 'success/:name_en', to: 'pages#return', as: :success
  post '/notify', to: 'pages#notify', as: :notify
  post '/notify_error', to: 'pages#notify_error', as: :notify_error

  get ':id', to: 'pages#show', as: :page
  get "errors/error_404"
  get "errors/error_500"

end
