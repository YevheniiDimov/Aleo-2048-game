import { configureStore } from '@reduxjs/toolkit'
import gridReducer from '../features/gridSlice'

export default configureStore({
  reducer: {
    grid: gridReducer,
  },
})