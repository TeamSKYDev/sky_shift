Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }
  # deviseのルートの上に他ルートを書かないこと。競合発生する可能性あり

  root "homes#top"
  get "home" => "homes#home", as: "home"
  get "home/select_schedule" => "homes#select_schedule", as: "select_schedule"
  get "home/submittion_destination" => "homes#submittion_destination", as: "submittion_destination"
  patch "home/change_store" => "homes#change_selected_store", as: "change_selected_store"
  resources :stores, except: [:index]



  patch "users/selecte_store" => "users#select_store", as: "select_store"
  patch "users/unsubscribe" => "users#unsubscribe", as: "unsubscribe"
  resources :users, only: [:show, :update]

  resources :rooms, only: [:new, :index, :create, :show, :destroy] do
    resources :messages, only: [:create, :index] do
      collection do
        get 'render_message'
      end
    end
    collection do
      get 'get_users'
      get 'select_store'
    end
  end
  get 'messages/render_message' => 'messages#render_message'

  resources :private_schedules

  patch "staffs/authentication" => "staffs/authentication_admin", as: "authentication"
  patch "staffs/unsubscribe" => "staffs/unsubscribe", as: "staff_unsubscribe"
  patch "staffs/permit" => "staffs/permit", as: "staff_permit"
  resources :staffs, only: [:new, :index, :create, :show, :update]

  resources :labels

  get "submitted_shifts/confirm" => "submitted_shifts#confirm", as: "confirm_submit_shift"
  patch "submitted_shifts/submit" => "submitted_shifts#submit", as: "submit_shift"
  resources :submitted_shifts, only: [:new, :create, :edit, :update, :destroy]

  get "shifts/daily" => "draft_shifts#daily", as: "daily_draft_shifts"
  get "shifts/submitted" => "draft_shifts#submitted", as: "show_submitted_shifts"
  resources :draft_shifts, only: [:new, :create, :index, :update, :destroy]

  post "shifts/create_all" => "decided_shifts#create_all", as: "create_all_decided_shifts"
  resources :decided_shifts, only: [:index, :create, :edit, :update, :destroy]

  get "task/:id/show_admin" => "tasks#show_admin", as: "admin_task"
  resources :tasks

  get "user_tasks/past" => "user_tasks#past_index", as: "past_user_tasks"
  get "user_tasks/past_assign" => "user_tasks#past_assign", as: "past_assign_user_tasks"
  get "user_tasks/staff_assign" => "user_tasks#staff_assign", as: "staff_assign_task"
  resources :user_tasks, only: [:new, :index, :create, :show, :update, :destroy]
end
