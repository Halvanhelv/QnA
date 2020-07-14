Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :questions, only: %i[index new show create update destroy] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :best_answer
      end
    end
  end

  resources :attachment, only: :destroy



  root to: 'questions#index'
end
