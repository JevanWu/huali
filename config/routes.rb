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

  get 'order', to: 'pages#order', as: :page
  get 'payment', to: 'pages#payment', as: :page
  get 'alipay', to: 'pages#alipay', as: :page
  get 'success', to: 'pages#show', as: :page
  get ':id', to: 'pages#show', as: :page
  #post 'payment', to: 'pages#alipay', as: :page
  get "errors/error_404"
  get "errors/error_500"

end
