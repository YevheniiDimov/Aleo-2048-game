'use client'
import { useSelector } from 'react-redux';
import GameBoard from './GameBoard';
import GameItem from './Gameitem';

function GameSelect(props) {
    const current_game_records = useSelector(state => state.grid.current_games);
    const score = useSelector(state => state.grid.score);
    const selected_game = useSelector(state => state.grid.selected_game);

    return (
        <div>
            {selected_game 
            ? <GameBoard publicKey={props.publicKey} requestCallback={props.requestCallback} transactionCallback={props.transactionCallback} /> 
            : <div>
                <h3 className='text-center text-2xl'>Select a Game</h3>
                <div className='d-flex flex-column flex-sm-row justify-content-between mt-5 w-100'>
                    {current_game_records.map((record, index) => <GameItem field={record.data} score={score} record={record} key={index} />)}
                </div>
              </div>
            }
        </div>
    );
}

export default GameSelect;
