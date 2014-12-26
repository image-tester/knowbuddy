KYU::Application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  get '/comments/user_comment/:id', to: 'comments#user_comment'
  get '/admin/deleted_posts/restore/:id', to:
                              'admin/deleted_posts#restore'

  get '/admin/deleted_posts/deleted_post/:id', to:
                              'admin/deleted_posts#deleted_post'
  get '/admin/deleted_posts/deleted_post', to:
                              'admin/deleted_posts#index'
  get '/admin/inactive_users/activate/:id', to:
                              'admin/inactive_users#activate'

  get '/admin/activity_types/activate/:id', to:
                              'admin/activity_types#activate'

  get '/admin/activity_types/deactivate/:id', to:
                              'admin/activity_types#deactivate'

  patch '/attachments/edit', to: 'attachments#create'


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
      get :contributors_pagination
      get :load_activities
      post :assign_vote
    end
    resources :comments, except: [:index]
  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  resources :users, only: [:edit, :update]

  get "home/index"

  root to: "posts#index"
end
