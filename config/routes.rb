require 'api_constraints.rb'

UnDataApi::Application.routes.draw do

  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
    get "/organizations" => 'organizations#index', metric: "organizations"
    get "/:organization/datasets" => 'datasets#organization_datasets', as: :organization_datasets, metric: "organization_datasets"
    get "/:organization/:dataset/countries" => 'countries#index', as: :dataset_countries, metric: "countries"
    get "/:organization/:dataset/:country/records" => 'records#index', as: :country_records, metric: "records"
    get "/:organization/:country/datasets" => 'datasets#country_datasets', as: :country_datasets, metric: "country_datasets"
  end

  get '*a' => 'application#invalid_request'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
