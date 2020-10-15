Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }
  # deviseのルートの上に他ルートを書かないこと。競合発生する可能性あり

  get "home" => "homes#home", as: "home"
  get "index" => "homes#index", as: "index"
  root "homes#top"
  patch "home/change/:id" => "homes#change_selected_store", as: "change_selected_store"
  resources :stores, except: [:index]



  patch "users/selecte_store" => "users#select_store", as: "select_store"
  patch "users/unsubscribe" => "users#unsubscribe", as: "unsubscribe"
  resources :users, only: [:show, :update]

  resources :rooms, only: [:new, :index, :create, :show, :destroy] do
    resources :messages, only: [:create, :index]
    collection do
      get 'get_users'
    end
  end


  resources :private_schedules

  patch "staffs/authentication" => "staffs/authentication_admin", as: "authentication"
  patch "staffs/unsubscribe" => "staffs/unsubscribe", as: "staff_unsubscribe"
  patch "staffs/permit" => "staffs/permit", as: "staff_permit"
  resources :staffs, only: [:new, :index, :create, :show, :update]

  resources :labels, except: [:new, :show]

  get "submitted_shifts/confirm" => "submitted_shifts#confirm", as: "confirm_submit_shift"
  patch "submitted_shifts/submit" => "submitted_shifts#submit", as: "submit_shift"
  resources :submitted_shifts, only: [:new, :create, :edit, :update, :destroy]

  get "shifts/daily" => "draft_shifts#daily", as: "daily_draft_shifts"
  get "shifts/submitted" => "draft_shifts#submitted", as: "show_submitted_shifts"
  resources :draft_shifts, only: [:new, :create, :index, :update, :destroy]

  post "shifts/create_all" => "decided_shifts#create_all", as: "create_all_decided_shifts"
  resources :decided_shifts, only: [:index, :create, :edit, :update, :destroy]

  resources :tasks, except: [:show]
end
