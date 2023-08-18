'use client'
import { setSelectedGame } from '@/store/gridSlice';
import { useDispatch, useSelector } from 'react-redux';
import Grid from '@/components/Grid';

function GameBoard(props) {
    const current_game_records = useSelector(state => state.grid.current_games);
    const field = useSelector(state => state.grid.field);
    const score = useSelector(state => state.grid.score);
    const selected_game = useSelector(state => state.grid.selected_game);
    
    return (
        <div>
            <h3 className='text-white text-lg'>Your score: {score}</h3>
            <Grid tile_data={field} />
        </div> 
    );
}

export default GameBoard;