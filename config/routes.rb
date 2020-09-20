Rails.application.routes.draw do

  devise_for :users
  # deviseのルートの上に他ルートを書かないこと。競合発生する可能性あり

  get "home" => "homes#home", as: "home"
  root "homes#top"
  resources :stores


end
