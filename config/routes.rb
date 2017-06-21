Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :set_like
      patch :set_dislike
      delete :cancel_vote
    end
  end

  resources :questions do
    resources :answers, shallow: true do
      patch :mark_best, on: :member
      concerns :votable
    end
    concerns :votable
  end

  resources :attachments, only: [:destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
