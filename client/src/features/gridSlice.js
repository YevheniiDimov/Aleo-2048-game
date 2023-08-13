import { createSlice } from '@reduxjs/toolkit';

export const gridSlice = createSlice({
  name: 'grid',
  initialState: {
    field: [
        [0, 4, 8, 0],
        [4, 1, 5, 10],
        [0, 9, 2, 4],
        [11, 7, 4, 3]
    ],
    value: 0
  },
  reducers: {
    increment: (state) => {
      state.value += 1;
      console.log('Increment: ', state.value);
    },
    decrement: (state) => {
      state.value -= 1;
    }
  },
});

export const { increment, decrement } = gridSlice.actions;
export default gridSlice.reducer;