KYU::Application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  match '/kyu_entries/remove_tag' => 'kyu_entries#remove_tag'

  match '/kyu_entries/related_tag' => 'kyu_entries#related_tag',
                                      as: 'related_tag'

  match '/kyu_entries/search' => 'kyu_entries#search'

  match '/kyu_entries/kyu_date' => 'kyu_entries#kyu_date'

  match '/kyu_entries/user_kyu' => 'kyu_entries#user_kyu'

  match '/comments/user_comment/:id' => 'comments#user_comment'
  match '/admin/deleted_posts/restore/:id' =>
                              'admin/deleted_posts#restore'

  match '/admin/deleted_posts/deleted_post/:id' =>
                              'admin/deleted_posts#deleted_post'
  match '/admin/deleted_posts/deleted_post' =>
                              'admin/deleted_posts#index'

  match '/admin/inactive_users/activate/:id' =>
                              'admin/inactive_users#activate'

  match '/admin/users/delete/:id' =>
                              'admin/users#delete'

  match '/kyu_entries/parse_content' => 'kyu_entries#parse_content'

 # match '/attachments/edit/:id' => 'attachments#create'

  resources :attachments
  resources :kyu_entries do
    get :autocomplete_tag_name, on: :collection
    resources :comments, except: [:index]
  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  resources :users, only: [:edit, :update]

  get "home/index"

  #root to: "home#index"
  root to: "kyu_entries#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # This route can be invoked with purchase_url(id: product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root to: 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended
  # for RESTful applications.
  # Note: This route will make all actions in every
  # controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end