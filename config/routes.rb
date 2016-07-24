Rails.application.routes.draw do
  root 'events#index'

  resources :events do
    resources :tickets
  end
  resources :venues, only: [:new, :create]
  resources :sessions, only: [:new, :create]

  resources :users do
    resources :manage_events do
      resources :manage_tickets, only: [:new, :create]
    end
    match '/manage_events/:id/update' => 'manage_events#publish', as: 'update', via: [:get, :post]
  end

  match 'logout' => 'sessions#destroy', as: 'logout', via: [:get, :post]
  
  end
