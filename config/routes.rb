Rails.application.routes.draw do

  root to: 'homes#top'
  get '/' => 'homes#top'
  get '/homes/about'

  namespace :admins do
    get 'homes/top'
    resources :workers, only: [:new, :create, :index, :show, :edit, :update]
    resources :workers do
      member do
        get 'password'
      end
    end
    resources :departments, only: [:index, :create, :edit, :update]
    resources :directors, only: [:index, :create, :edit, :update]
    resources :locations, only: [:index, :create, :edit, :update]
    resources :working_hours, only: [:index, :create, :edit, :update]
    resources :attendances, only: [:show, :edit, :update] do
      collection do
        post '/:id', to: 'attendances#show', as: 'timecard'
        post '/:id/edit', to: 'attendances#edit', as: 'timecard/edit'
      end
    end
    resources :excels, only: [:index]
    resources :pdfs, only: [:index]
  end

  namespace :workers do
    get 'homes/top'
    resources :workers, only: [:show]
    resources :attendances, only: [:index, :create, :show, :edit, :update] do
      collection do
        post 'start'
        post 'finish'
        post 'start_breaktime'
        post 'finish_breaktime'
        post '/:id', to: 'attendances#show', as: 'timecard'
        post '/:id/edit', to: 'attendances#edit', as: 'timecard/edit'
      end
    end
  end

  devise_for :workers, controllers:{
    sessions:      'workers/sessions',
    passwords:     'workers/passwords',
    registrations: 'workers/registrations'
  }

  devise_for :admins, controllers:{
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
