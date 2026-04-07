Rails.application.routes.draw do
  devise_for :users
  # これで以下のようなルーティングが自動生成される
  # /users/sign_up（新規登録）
  # /users/sign_in（ログイン）
  # /users/sign_out（ログアウト）

  root "top#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
