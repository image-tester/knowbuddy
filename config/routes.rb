KYU::Application.routes.draw do
  mount Resque::Server.new, at: "/resque"

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

  match '/admin/activity_types/activate/:id' =>
                              'admin/activity_types#activate'

  match '/admin/activity_types/deactivate/:id' =>
                              'admin/activity_types#deactivate'

 match '/attachments/edit' => 'attachments#create'

  resources :attachments, only: [:create, :destroy]
  resources :posts do
    collection do
      get :autocomplete_tag_name
      get :remove_tag
      get :related_tag
      get :render_contributors_pagination
      get :search
      get :post_date
      get :user_posts
      post :parse_content
      post :draft
      get :draft_list
    end
    resources :comments, except: [:index]
  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  resources :users, only: [:edit, :update]

  get "home/index"

  #root to: "home#index"
  root to: "posts#index"
end
