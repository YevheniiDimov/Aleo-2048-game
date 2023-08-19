'use client'
import { WalletAdapterNetwork, Transaction } from "@demox-labs/aleo-wallet-adapter-base";
import { PlusSquare, ArrowLeftRight, Medal, Frown } from "lucide-react";
import { useDispatch, useSelector } from 'react-redux';
import { getSpendableRecord } from "@/pages/game";
import { useEffect } from 'react';
import Grid from '@/components/Grid';

const useKeyDown = (handler, deps = []) => {
    useEffect(() => {
        document.addEventListener("keydown", handler);
        // clean up
        return () => {
            document.removeEventListener("keydown", handler);
        };
    }, deps);
};

const findNextState = (records, record) => {
    const found = records.filter(r => r.data.prev_state_address === record.data.state_address)[0];
    if (found.length > 0) { return found[0]; }
    return null;
}

function GameBoard(props) {
    const credit_records = useSelector(state => state.wallet.credit_records);
    const current_game_records = useSelector(state => state.grid.current_games);
    const field = useSelector(state => state.grid.field);
    const score = useSelector(state => state.grid.score);
    const selected_game = useSelector(state => state.grid.selected_game);
    const dispatch = useDispatch();

    let side = -1;
    let checkInterval = null;

    const makeMove = async () => {
        let payRecord = await getSpendableRecord(credit_records, 18000000);
        console.log('PayRecord Game Board');
        console.log(payRecord);
        if (payRecord) {
            const microcredits = Number(payRecord.data.microcredits.slice(0, -11)); 
            console.log('Microcredits: ', microcredits);
        } 
        else {
            throw NotEnoughCreditsException('Not enough credits on records');
        }

        const inputs = [selected_game, `${side}u8`];

        console.log('Inputs:');
        console.log(inputs);

        const aleoTransaction = Transaction.createTransaction(
        props.publicKey,
        WalletAdapterNetwork.Testnet,
        'game2048_1elm7z.aleo',
        'move_tiles',
        inputs, 18000000
        );

        if (props.transactionCallback) {
            const result = await props.transactionCallback(aleoTransaction);
            console.log('Result Game Board');
            console.log(result);
        }
    }

    const generateTile = async () => {
        let payRecord = await getSpendableRecord(credit_records, 10000000);
        console.log('PayRecord Generate Tile');
        console.log(payRecord);
        if (payRecord) {
            const microcredits = Number(payRecord.data.microcredits.slice(0, -11)); 
            console.log('Microcredits: ', microcredits);
        } 
        else {
            throw NotEnoughCreditsException('Not enough credits on records');
        }

        const inputs = [selected_game];

        console.log('Inputs:');
        console.log(inputs);

        const aleoTransaction = Transaction.createTransaction(
        props.publicKey,
        WalletAdapterNetwork.Testnet,
        'game2048_1elm7z.aleo',
        'generate_tile',
        inputs, 10000000
        );

        if (props.transactionCallback) {
            const result = await props.transactionCallback(aleoTransaction);
            console.log('Result Generate Tile');
            console.log(result);
        }
    }
    
    useKeyDown(e => {
        switch (e.code) {
            case 'KeyW': { side = 0; break; }
            case 'KeyD': { side = 1; break; }
            case 'KeyS': { side = 2; break; }
            case 'KeyA': { side = 3; break; }
            default: { side = -1; break; }
        } 

        const game_state = Number(selected_game.data.game_state.slice(0, -10));

        if (side >= 0 && game_state < 2) { // Doesn't need a tile
            makeMove();
        }
    }, []);
    
    return (
        <div>
            <h3 className='text-lg my-2'>Your score: {score}</h3>
            <Grid tile_data={field} />
            { Number(selected_game.data.game_state.slice(0, -10)) === 4 &&
                <h3 className='text-lg flex mt-3 text-center'><Frown size={32} /> You have lost</h3>
            }
            { Number(selected_game.data.game_state.slice(0, -10)) === 3 &&
                <h3 className='text-lg flex mt-3 text-center'><Medal size={32} /> You have won!</h3>
            }
            { Number(selected_game.data.game_state.slice(0, -10)) === 2 &&
                <button className='flex justify-content-between btn btn-dark btn-lg border border-1 border-white rounded mt-5 w-100'
                onClick={generateTile}>
                  <PlusSquare size={32} /> Generate a new Tile
                </button>
            }
            { Number(selected_game.data.game_state.slice(0, -10)) === 1 &&
                <h3 className='text-lg flex mt-3 text-center'><ArrowLeftRight size={32} /> Make a new move to the side by pressing WASD</h3>
            }
            { Number(selected_game.data.game_state.slice(0, -10)) === 0 &&
                <h3 className='text-lg flex mt-3 text-center'><ArrowLeftRight size={32} /> Use WASD to move the tiles (press any right to let to generate the tile)</h3>
            }
        </div> 
    );
}

export default GameBoard;