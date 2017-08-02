import {combineReducers} from 'redux';
import games from './gameReducer';
import board from './boardReducer';

const rootReducer = combineReducers({
    contacts
    games
});

export default rootReducer;
