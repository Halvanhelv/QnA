Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    post 'custom_email', to: 'oauth_callbacks#custom_email'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # default_url_options host: '127.0.0.1'
  concern :votable do
    member do
      patch :positive_vote
      patch :negative_vote
    end
  end
  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, only: %i[index new show create update destroy], concerns: %i[votable] do
    resources :comments, defaults: { commentable: 'questions' }
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable] do
      member do
        patch :best_answer
      end
      resources :comments, defaults: { commentable: 'answers' }

    end
  end

  resources :attachment, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  mount ActionCable.server => '/cable'
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
      get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy]
    end
  end
end
