Changanhua::Application.routes.draw do

  resources :pages, only: :show
  get ':id', to: 'pages#show', as: :page

  ActiveAdmin.routes(self)

  resources :products, :only => [:show, :index]

  resources :collections, :only => [:show, :index]

  devise_for :administrators

  authenticated :administrators do
    root :to => "home#index"
  end

  root :to => "home#index"

end
