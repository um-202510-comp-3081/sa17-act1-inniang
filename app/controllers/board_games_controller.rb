

class BoardGamesController < ApplicationController
    def index
        @board_games = BoardGame.all
    end

    def show
        @board_game = BoardGame.find_by(id: params[:id])
    
        unless @board_game
          flash[:alert] = "Board game not found."
          redirect_to board_games_path  # Redirect to index if the game doesn't exist
        end
      end
end

  
