Changanhua::Application.routes.draw do

  resources :products

  devise_for :administrators

  authenticated :administrators do
    root :to => "home#index"
  end

  root :to => "home#index"

  resources :administrators, :only => [:show, :index]
end
