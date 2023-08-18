import { createSlice } from '@reduxjs/toolkit';

export const gridSlice = createSlice({
  name: 'grid',
  initialState: {
    field: [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
    ],
    game_records: [],
    current_games: [],
    selected_game: null,
    score: 0,
    value: 0
  },
  reducers: {
    setGameRecords: (state, action) => {
      state.game_records = action.payload.game_records;
    },
    setCurrentGames: (state, action) => {
      state.current_games = action.payload.current_games;
    },
    setSelectedGame: (state, action) => {
      state.selected_game = action.payload.selected_game;
    }
  }
});

export const { setGameRecords, setCurrentGames, setSelectedGame } = gridSlice.actions;
export default gridSlice;