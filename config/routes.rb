Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  concern :votable do
    member do
      patch :positive_vote
      patch :negative_vote
    end
  end

  resources :questions, only: %i[index new show create update destroy], concerns: %i[votable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable] do
      member do
        patch :best_answer
      end
    end
  end

  resources :attachment, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  root to: 'questions#index'

end
