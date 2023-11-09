# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tickets
  devise_for :users, skip: %i[sessions registrations]
  devise_scope :user do
    get 'login',  to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    get 'log_out' => 'devise/sessions#destroy', as: :destroy_user_session

    get 'signup' => 'devise/registrations#new', as: :new_user_registration
    post 'signup' => 'devise/registrations#create', as: :user_registration
    put 'signup' => 'devise/registrations#update', as: :update_user_registration
    patch 'signup' => 'devise/registrations#update', as: :patch_user_registration

    get 'edit-user' => 'devise/registrations#edit', as: :edit_user_registration
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'contact' => 'auth_pages#contact'

  post 'tickets/:ticket_id/comments' => 'ticket_comments#new', as: :new_ticket_comment

  post 'notifications' => 'notification#mark_notifications_as_read', as: :notification_mark_as_read

  get 'notification/:notification_id' => 'notification#redirect_to_notification', as: :notification_redirect

  # Defines the root path route ("/")
  root 'auth_pages#index'
end
