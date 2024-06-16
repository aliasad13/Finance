Rails.application.routes.draw do
  devise_for :users
  root 'welcome#home'
  post '/dark_mode', to: 'application#dark_mode'
  patch '/dark_mode', to: 'application#dark_mode'
end
