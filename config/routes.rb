Rails.application.routes.draw do
  devise_for :users
  get '/' => 'homes#top'

  resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resource :favorites, only: [:create , :destroy]
    resources :post_comments, only: [:create , :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
