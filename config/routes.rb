Changanhua::Application.routes.draw do

  ActiveAdmin.routes(self)

  resources :products

  devise_for :administrators

  authenticated :administrators do
    root :to => "home#index"
  end

  root :to => "home#index"

  resources :administrators, :only => [:show, :index]
end
