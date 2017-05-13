Rails.application.routes.draw do
  resources :comments
  resources :statuses
  resources :priorities
  resources :verticals
  resources :request_types
  resources :roles
  resources :tasks

  devise_for :users
    resources :users do
      member do
        get ':type/serve_avatar', action: 'serve_avatar'
        put :approve
      end
    end

  devise_scope :user do
    authenticated :user do
      root 'tasks#index', as: :authenticated_root
    end
  end
  root 'devise/sessions#new'

  get  '/new_user_no_devise',  to: 'users#new'
  post '/create_user_no_devise', to: 'users#create'

  patch '/update_user_no_devise/:id', to: 'users#update'
  patch '/changepw', to: 'users#changepw'


  get '/delete_avatar', to: 'users#destroy_avatar'
  get ':id/:type/serve_doc', to: 'attachments#serve_doc'
  get '/delete_doc', to: 'attachments#destroy'

end
