KYU::Application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  match '/kyu_entries/remove_tag' => 'kyu_entries#remove_tag'

  match '/kyu_entries/related_tag' => 'kyu_entries#related_tag',
                                      as: 'related_tag'

  match '/kyu_entries/render_contributors_pagination' => 'kyu_entries#render_contributors_pagination'

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

  match '/admin/activity_types/activate/:id' =>
                              'admin/activity_types#activate'

  match '/admin/activity_types/deactivate/:id' =>
                              'admin/activity_types#deactivate'

 # match '/attachments/edit/:id' => 'attachments#create'

  resources :attachments, only: [:create, :destroy]
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
end