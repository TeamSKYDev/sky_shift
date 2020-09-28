Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }
  # deviseのルートの上に他ルートを書かないこと。競合発生する可能性あり

  get "home" => "homes#home", as: "home"
  root "homes#top"
  patch "home/change/:id" => "homes#change_selected_store", as: "change_selected_store"
  resources :stores, except: [:index]



  patch "users/selecte_store" => "users#select_store", as: "select_store"
  patch "users/unsubscribe" => "users#unsubscribe", as: "unsubscribe"
  resources :users, only: [:show, :update]

  resources :rooms, only: [:new, :index, :create, :show, :destroy] do
    resources :messages
    collection do
      get 'get_users'
    end
  end

  patch "staffs/authentication" => "staffs/authentication_admin", as: "authentication"
  patch "staffs/unsubscribe" => "staffs/unsubscribe", as: "staff_unsubscribe"
  patch "staffs/permit" => "staffs/permit", as: "staff_permit"
  resources :staffs, only: [:new, :index, :create, :show, :update]

  resources :labels, except: [:new, :show]

  resources :submitted_shifts, only: [:new, :create, :edit, :update, :destroy]
end
