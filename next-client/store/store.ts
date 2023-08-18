import { configureStore } from "@reduxjs/toolkit";
import { gridSlice } from "./gridSlice";
import { walletSlice } from "./walletSlice";

export default configureStore({
  reducer: {
    [gridSlice.name]: gridSlice.reducer,
    [walletSlice.name]: walletSlice.reducer,
  },
  devTools: true,
});