Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      put :mark_best, on: :member
    end
  end
  resource :attachments, only: [:destroy]

  root "questions#index"
end
