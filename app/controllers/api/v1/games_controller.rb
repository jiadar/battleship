module Api
  module V1
    class GamesController < Api::V1::ApiController
      respond_to :json

      # GET a game for current game state, PUT (update) a game to make a move
      # (return error if it isnt your move, otherwise some success message)

      def create
        if !logged_in?
          render status: 403, json: {
            error: "Must be logged in to create a new game!"
          } and return
        end

        @game = Game.new
        setup_game

        if @game.save!
          render status: 200, json: {
            guid: @game.guid
          } and return
        end

        render status: 400, json: {
          error: "Unable to create new game"
        }
      end

      def show
        game = Game.find_by_guid(params[:guid])

        if game
          render status: 200, json: {
            game: game.as_json
          }
        else
          render status: 404, json: {
            error: "Game id does not exist"
          }
        end
      end

      def join
        guid = params[:guid]

        @game = Game.find_by_guid(guid)
        @game.add_second_player(current_user.id)
        @game.advance_state

        if @game.errors.empty? && @game.save
          render status: 200, json: {
            game: @game
          }
        else
          render status: 404, json: {
            error: @game.errors
          }
        end
      end

      private

      def game_params
        params.require(:game)
      end

      def setup_game
        @game.player_one = current_user.id
        @game.current_turn_id = current_user.id
      end

    end
  end
end
