import { configureStore } from "@reduxjs/toolkit";
import { gridSlice } from "./gridSlice";

export default configureStore({
  reducer: {
    [gridSlice.name]: gridSlice.reducer,
  },
  devTools: true,
});