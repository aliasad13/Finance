Rails.application.routes.draw do
  root 'welcome#home'

  # get 'my_anime_list/oauth_callback'
  devise_for :users
  patch '/dark_mode', to: 'application#dark_mode'

  get 'oauth_callback', to: 'my_anime_list#oauth_callback'
  get 'authorize', to: 'my_anime_list#authorize'
  get 'animes', to: 'my_anime_list#animes'
  get 'mangas', to: 'my_anime_list#mangas'

  # root 'my_anime_list#index' # Or any other controller action you prefer
  # root 'my_anime_list#index' # Example: Set root to my_anime_list#index
  get 'movies_and_shows', to: 'media#index'
end
