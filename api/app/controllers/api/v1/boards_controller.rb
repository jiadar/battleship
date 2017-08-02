module Api
  module V1
    class BoardsController < Api::V1::ApiController

      def show
        game = Game.find_by_guid(params[:guid])
        board = Board.find_by_game_id_and_user_id(params[:guid], current_user.id)

        if game && game.has_player?(current_user.id)
          render status: 200, json: {
            game: game.as_json,
            board: board.as_json
          }
        else
          render status: 403, json: {
            error: "Cannot view board state of a game you do not belong to"
          }
        end
      end

      def update
        game = Game.find_by_guid(params[:guid])
        board = Board.find_by_game_id_and_user_id(game.id, current_user.id)

        if game.state == "placing" && !board.placed?
          board.place_ships(board_params[:ships])
          if board.errors.empty?
            game.try_advance_state!
            render status: 200, json: {
              game: game.as_json,
              board: board.as_json
            }
          else
            render status: 403, json: {
              error: board.errors
            }
          end
        elsif game.state == "playing" && game.current_turn_id == current_user.id
          board = game.opponents_board(current_user)
          shot_result = game.handle_shot(board_params[:shot])
          game.swap_turns!
          game.try_advance_state!
          render status: 200, json: {
            game: game.as_json,
            shot_result: shot_result,
            board: board.as_json
          }
        else
          render status: 400, json: {
            error: "Cannot update board while game is in '#{game.state}' state for player id #{game.current_turn_id}"
          }
        end
      end

      private

      def board_params
        params.require(:board).permit(:shot => [], :ships => [ :ship => [ :coord => [] ] ] )
      end

    end
  end
end
