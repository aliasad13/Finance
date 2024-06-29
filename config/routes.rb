Rails.application.routes.draw do
  root 'welcome#home'

  # get 'my_anime_list/oauth_callback'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  patch '/dark_mode', to: 'application#dark_mode'

  # get 'oauth_callback', to: 'my_anime_list#oauth_callback'
  get 'authorize', to: 'my_anime_list#authorize'
  get 'animes', to: 'my_anime_list#animes'
  get 'mangas', to: 'my_anime_list#mangas'

  # root 'my_anime_list#index' # Or any other controller action you prefer
  # root 'my_anime_list#index' # Example: Set root to my_anime_list#index
  get 'movies_and_shows', to: 'media#index'

  resources 'users' do
    member do
      get 'favorite_movies'
      get 'friends'
    end

    collection do
    end
  end

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  mount ActionCable.server => '/cable'

  resources 'friendships', only: [] do

    # member do
    #   post 'add_friend'
    #   delete 'remove_friend'
    # end

    collection do
      get 'friends'
    end

  end

  resources :friendships, only: [] do
    member do
      post 'add_friend'
      delete 'remove_friend'
    end
  end

  resources :friend_requests, only: [] do
    member do
      post 'create_friend_request'
      put :accept
      put :reject
      delete 'remove_friend_request'
    end
    collection do
      get 'friend_requests'
    end
  end

  resources 'media', only: [] do
    collection do
      get :movies
      get :tv_shows
    end
    member do
      get :movie
    end
  end

  resources 'movies', only: [] do
    member do
      post 'add_favorite'
      delete 'remove_favorite'
      get 'favorites'
    end

    collection do
    end
  end

  end
