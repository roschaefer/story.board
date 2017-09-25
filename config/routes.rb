Rails.application.routes.draw do
  devise_for :users
  resources :chains
  resources :actuators do
    member do
      post :activate
      post :deactivate
    end
  end
  resources :events, except: :show
  resources :events, only: :show, :constraints => {:format => :json}
  post 'events/:id/start', to: 'events#start', as: 'start_event'
  post 'events/:id/stop', to: 'events#stop', as: 'stop_event'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  get 'reports/current', to: 'reports#current', as: 'current_report'
  get 'reports/present/:report_id', to: 'reports#present', as: 'present_report'
  get 'reports/preview/:report_id', to: 'reports#preview', as: 'preview_report'

  get 'reports/:report_id/chatfuel/:topic', to: 'chatfuel#show'
  # route for chatfuel questions and answers
  get 'reports/:report_id/chatfuel/text_components/:text_component_id/answer_to_question/:index', to: 'chatfuel#answer_to_question', as: 'answer_to_question'

  resources :channels, only: [:edit, :show, :update]

  resources :reports, param: :report_id # shallow nesting to avoid id param like :report_report_id
  resources :reports, only: [] do # only: [] to remove duplicate top level routes
    resources :diary_entries, only: [:index, :show]
    resources :text_components do
      get 'duplicate', on: :member
    end
    resources :triggers
    resources :sensors do
      member do
        put :start_calibration
        put :stop_calibration

        resources :sensor_readings, only:[:show, :create, :index], default: { format: :json }
        post 'sensor_readings/debug', to: 'sensor_readings#debug', default: { format: :json }
      end
    end
  end

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
