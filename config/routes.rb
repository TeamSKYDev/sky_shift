Rails.application.routes.draw do

  devise_for :users
  # deviseのルートの上に他ルートを書かないこと。競合発生する可能性あり

  get "home" => "homes#home", as: "home"
  root "homes#top"

  patch "staffs/authentication" => "staffs/authentication_admin", as: "authentication"
  patch "staffs/unsubscribe" => "staffs/unsubscribe", as: "staff_unsubscribe"
  resources :staffs, only: [:new, :index, :create, :show, :update]
end
