Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers do
      patch :mark_best, on: :member
    end
    patch :set_like, on: :member
  end

  resources :attachments, only: [:destroy]

  root to: "questions#index"
end
