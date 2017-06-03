Rails.application.routes.draw do
  devise_for :users
  resources :text_components, except: [:edit, :new]
  resources :chains
  resources :actuators do
    member do
      post :activate
      post :deactivate
    end
  end
  resources :events, except: :show
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  get 'reports/current', to: 'reports#current', as: 'current_report'
  get 'reports/present/:id', to: 'reports#present', as: 'present_report'
  get 'reports/preview/:id', to: 'reports#preview', as: 'preview_report'

  get 'chatfuel/:topic', to: 'chatfuel#show'
  # route for chatfuel questions and answers
  get 'chatfuel/text_components/:text_component_id/answer_to_question/:index', to: 'chatfuel#answer_to_question', as: 'answer_to_question'

  get '/smaxtecs_api/temperature', to: 'smaxtecs_api#get_temperature'

  resources :channels, only: [:edit, :show, :update]
  resources :reports

  resources :triggers
  resources :sensors do
    member do
      put :start_calibration
      put :stop_calibration
    end
  end
  resources :sensor_readings, default: { format: :json }
  post 'sensor_readings/fake', to: 'sensor_readings#fake', default: { format: :json }


  root to: redirect('/reports/current')

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
