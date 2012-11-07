Changanhua::Application.routes.draw do


  resources :products, :only => [:show]

  resources :collections, :only => [:show]
  # non-individual collections routes
  match '/collections/all', :to => 'collections#all'
  match '/collections/:id', :to => 'collections#show'

  devise_for :administrators

  devise_for :users

  root :to => "home#index", :as => :home

  ActiveAdmin.routes(self)

  authenticated :administrators do
    root :to => "admin#index"
  end

  get 'order', to: 'pages#order', as: :order
  get 'payment/:product_id', to: 'pages#payment', as: :payment
  post 'payment/:product_id', to: 'pages#alipay', as: :alipay
  get 'success/:id', to: 'pages#success', as: :success
  get ':id', to: 'pages#show', as: :page
  get "errors/error_404"
  get "errors/error_500"

end
