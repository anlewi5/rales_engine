Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do 
    namespace :v1 do 
      resources :merchants, only: [:index]

      namespace :items do
        get '/find', to: 'search#show'
      end
      resources :items,     only: [:index, :show]
    end
  end
end