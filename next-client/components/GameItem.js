'use client'
import { setSelectedGame } from '@/store/gridSlice';
import { useDispatch } from 'react-redux';
import Grid from '@/components/Grid';

function GameItem(props) {
    const dispatch = useDispatch();

    const getTile = (number, position) => {
        return (number >> position) & 0xF;
    }

    let field = [];

    for (let i = 4; i > 0; i--) {
        let row = [];
        for (let j = 0; j < 16; j += 4) {
            row.push(getTile(props.field, j + (16 * i)))
        }

        field.push(row);
    }

    const selectTile = async () => {
        dispatch(setSelectedGame({selected_game: props.record}));
    }

    console.log('Field');
    console.log(field);
    
    return (
        <div className='d-flex flex-column w-100 cursor-pointer hover:bg-sky-700' onClick={selectTile}>
            <Grid tile_data={field} />
            <h3 className='text-white mt-3 text-lg'>Score: {props.score}</h3>
        </div>
    );
}

export default GameItem;