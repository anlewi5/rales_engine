Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do 
    namespace :v1 do 

      namespace :merchants do 
        get '/find_all', to: 'search#index'
        get '/random', to: 'search#show'
        get '/find',   to: 'search#show'
      end

      namespace :customers do 
        get '/find',   to: 'search#show'
        get '/random', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      namespace :items do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
        get '/random', to: 'search#show'
      end

      resources :items,     only: [:index, :show]
      resources :merchants, only: [:index, :show]
      resources :customers, only: [:index, :show]

    end
  end


end
     

    
      
  