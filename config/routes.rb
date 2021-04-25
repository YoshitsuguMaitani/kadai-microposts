Rails.application.routes.draw do
    root to: "toppages#index"
    
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get "signup", to: "users#new"
    #フォロー中のユーザーとフォローされているユーザー一覧を表示するページ
    resources :users, only: [:index, :show, :create] do
      member do
         get :followings
         get :followers
      end
      collection do
         get :search
      end
    end
    
    resources :microposts, only: [:create, :destroy]
    #ログインユーザーがフォロー/アンフォローできるようにするルーティング
    resources :relationships, only: [:create, :destroy]
end
