Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      put :mark_best, on: :member
    end
  end
  
  resources :attachments, only: :destroy
end
