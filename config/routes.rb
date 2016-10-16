Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root 'questions#index'

  concern :votable do
    member do
      put 'vote_up'
      put 'vote_down'
      put 'vote_cancel'
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      put :mark_best, on: :member
    end
  end
  
  resources :attachments, only: :destroy
end
