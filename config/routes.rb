Rails.application.routes.draw do
  get '/' => 'homes#top'
  devise_for :users

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resource :relationships, only: [:create, :destroy]
    resources :favorites, only: [:index]
    resources :bookmarks, only: [:index]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resource :favorites, only: [:create , :destroy]
    resource :bookmarks, only: [:create , :destroy]
    resources :post_comments, only: [:create , :destroy]
    get 'timeline'
    collection do
      get 'search'
      get 'category_result'
      get 'tag_result'
    end
  end

  resources :notifications, only: [:index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
