Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root 'static_pages#home'                                                      #TOPページ用
  get  '/help',    to: 'static_pages#help'                                      #HELPページ用
  get  '/about',   to: 'static_pages#about'                                     #ABOUTページ用
  get  '/contact', to: 'static_pages#contact'                                   #CONTACTページ用
  get  '/signup',  to: 'users#new'                                              #ユーザ作成用ビュー
  post '/signup',  to: 'users#create'                                           #ユーザ作成時のPOST
  get  '/login',   to: 'sessions#new'                                           #ログイン画面用ビュー
  post  '/login',  to: 'sessions#create'                                        #ログイン時のsession作成用
  delete '/logout',  to: 'sessions#destroy'                                     #ログアウト時のsession削除用
  resources :users                                                              #usersコントローラのRESTfulなルーティング
  resources :account_activations, only: [:edit]                                 #account_activationsコントローラのRESTfulのうちのeditのみ
  resources :password_resets,     only: [:new, :create, :edit, :update]         #password_resetsコントローラのRESTfulのうちのnew,create,edit,update
  resources :microposts,          only: [:create, :destroy]                     #micropostsコントローラのcreate,destroyのみ定義
end