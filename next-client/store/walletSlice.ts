import { createSlice } from '@reduxjs/toolkit';

export const walletSlice = createSlice({
  name: 'wallet',
  initialState: {
    last_record: null,
    credit_records: []
  },
  reducers: {
    setLastRecord: (state, action) => {
        state.last_record = action.payload.last_record;
    },
    setCreditRecords: (state, action) => {
        state.credit_records = action.payload.credit_records;
    }
  }
});

export const { setLastRecord, setCreditRecords } = walletSlice.actions;
export default walletSlice;