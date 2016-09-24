Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      put 'vote_up'
      put 'vote_dowm'
      put 'vote_decline'
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true do
      put :mark_best, on: :member
    end
  end
  
  resources :attachments, only: :destroy
end
