import * as types from '../actions/actionTypes';

export default function gameReducer(state=[], action) {
  switch (action.type) {

  case types.CREATE_GAME:
      // Update the state to create the game and return

  case types.GAME_WAITING:
      // Update the state to waiting for player 2 and return
      return action.game;

  case types.GAME_PLACING:
      // Update the state to placing and return
      return action.game;

  case types.GAME_PLAYING:
      // Update the state to playing and return
      return action.game;

  case types.GAME_TURN:
      // Update the state after a turn and return
      return action.game;
      
  case types.GAME_FINISHED:
      // Update the state to finished and return
      return action.game;

  default:
      return state;
  }
}
