Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :set_like
      patch :set_dislike
      delete :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      patch :mark_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
