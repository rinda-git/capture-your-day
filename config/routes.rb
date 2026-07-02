Rails.application.routes.draw do
  get "favorites/create"
  get "favorites/destroy"
  get "line_connections/show"
  get "mypages/show"
  get "home/index"
  devise_for :users
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"
  # これで以下のようなルーティングが自動生成される
  # /users/sign_up（新規登録）
  # /users/sign_in（ログイン）
  # /users/sign_out（ログアウト）

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "top#index", as: :unauthenticated_root
  end

  # root "top#index"
  # root to "home#index"
  resources :journals, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
    collection do
      get "calendar"
    end
  end

  resources :mistakes, only: [ :index, :show, :new, :create, :destroy ]
  resource :user, only: [ :show, :edit, :update, :destroy ]
  resources :journal_corrections, only: [ :index, :show ]
  resource :mypage, only: [ :show ]
  resource :line_connection, only: [ :show, :create, :destroy ]
  resource :notification_setting, only: [ :show, :update ]
  # mistake_idを渡して、current_userのお気に入りから探して消す
  resources :favorites, only: [ :create, :index ] do
    delete :destroy, on: :collection
  end

  # テスト用ルーティング　あとで削除する
  # get '/test500', to: 'application#test500'

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # LINE Messaging API(Webhook受信口)
  post "line/webhook", to: "line_webhooks#create"

  # LINE連携開始
  get "/line_login", to: "line_logins#new", as: :line_login
  # LINE認証・許可後に戻ってくるURL
  get "/line_login/callback", to: "line_logins#callback"
  # Defines the root path route ("/")
  # root "posts#index"
  # 開発環境のみメール確認ツール
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
