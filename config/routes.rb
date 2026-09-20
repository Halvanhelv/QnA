# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount MissionControl::Jobs::Engine, at: '/jobs'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    post 'custom_email', to: 'oauth_callbacks#custom_email'
  end

  concern :votable do
    resource :upvote, only: :create
    resource :downvote, only: :create
  end

  resources :questions, concerns: %i[votable] do
    resources :comments, only: %i[new create], defaults: { commentable: 'questions' }
    resources :answers, shallow: true, only: %i[create edit update destroy], concerns: %i[votable] do
      resource :acceptance, only: :create
      resources :comments, only: %i[new create], defaults: { commentable: 'answers' }
    end
    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resources :attachment, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  get 'search', to: 'search#search'

  root to: 'questions#index'

  get 'up', to: 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end
end
