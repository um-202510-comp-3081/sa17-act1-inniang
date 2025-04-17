# config/routes.rb

Rails.application.routes.draw do
  resources :board_games, only: [:index, :show]
  root "board_games#index"
end

