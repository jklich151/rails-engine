Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :items, except: [:new, :edit]
      resources :merchants, except: [:new, :edit]
      namespace :merchants do
        get '/:merchant_id/:items', to: 'items#show'
      end
      namespace :items do
        get '/:item_id/:merchants', to: 'merchants#show'
      end
    end
  end
end
