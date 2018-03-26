Rails.application.routes.draw do
  root 'static_pages#home'                                                      #TOPページ用
  get  '/help',    to: 'static_pages#help'                                      #HELPページ用
  get  '/about',   to: 'static_pages#about'                                     #ABOUTページ用
  get  '/contact', to: 'static_pages#contact'                                   #CONTACTページ用
  get  '/signup',  to: 'users#new'                                              #ユーザ作成用ビュー
  post '/signup',  to: 'users#create'                                           #ユーザ作成時のPOST
  get  '/login',   to: 'sessions#new'                                           #ログイン画面用ビュー
  post  '/login',  to: 'sessions#create'                                        #ログイン時のsession作成用
  delete '/logout',  to: 'sessions#destroy'                                      #ログアウト時のsession削除用
  resources :users                                                              #usersコントローラのRESTfulなルーティング
end