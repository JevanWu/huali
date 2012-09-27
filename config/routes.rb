Changanhua::Application.routes.draw do

  ActiveAdmin.routes(self)
  
  resources :products, :only => [:show, :index]

  resources :collections, :only => [:show, :index]

  devise_for :administrators

  authenticated :administrators do
    root :to => "home#index"
  end

  root :to => "home#index"
  
  get ':id', to: 'pages#show', as: :page
 

end
