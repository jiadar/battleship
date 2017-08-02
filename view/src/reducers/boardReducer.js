import * as types from '../actions/actionTypes';

export default function boardReducer(state=[], action) {
  switch (action.type) {
    case types.PLACE:
      // Update the board with the ships to state and return 
      return action.contacts;

  case types.SHOOT:
      // Update the board with the new shot to state and return
      return [
        ...state,
        Object.assign({}, action.contact)
      ];

    default:
      // Return state passed as parameter
      return state;
  }
}
