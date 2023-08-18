'use client'
import { WalletNotConnectedError, WalletAdapterNetwork, Transaction } from "@demox-labs/aleo-wallet-adapter-base";
import { setGameRecords, setCurrentGames, setLastTransaction } from '@/store/gridSlice';
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import { RefreshCcwDot, Play } from 'lucide-react';
import { useSelector, useDispatch } from 'react-redux';
import { setCreditRecords } from '@/store/walletSlice';
import GameSelect from "../components/GameSelect";
import 'bootstrap/dist/css/bootstrap.min.css';

function NotEnoughCreditsException(message) {
  const error = new Error(message);

  error.code = "NOT_ENOUGH_CREDITS";
  return error;
}

export default function Game() {
  const credit_records = useSelector(state => state.wallet.credit_records);
  const current_game_records = useSelector(state => state.grid.game_records);
  const last_transaction = useSelector(state => state.grid.last_transaction);
  const dispatch = useDispatch();

  const { publicKey, requestRecords, requestTransaction } = useWallet();

  const getCurrentGames = async (records) => {
    let last_states = records.map(r => Number(r.data.prev_state_address.slice(0, -12)));
    return records.filter(r => !last_states.includes(Number(r.data.state_address.slice(0, -12))))
  }

  const loadGameRecords = async () => {
    const program = "game2048_1elm7z.aleo";
    if (!publicKey) throw new WalletNotConnectedError();
    if (requestRecords) {
      const records = await requestRecords(program);
      const current_records = await getCurrentGames(records);
      console.log('Game Records');
      console.log(records);
      console.log('Current Game Records');
      console.log(current_records);
      dispatch(setGameRecords({game_records: records}));
      dispatch(setCurrentGames({current_games: current_records}));
    }
  };

  const loadCreditRecords = async () => {
    const program = "credits.aleo";
    if (!publicKey) throw new WalletNotConnectedError();
    if (requestRecords) {
      const records = await requestRecords(program);
      dispatch(setCreditRecords({credit_records: records}));
    }
  };

  const getSpendableRecord = async (records, min_microcredits) => {
    for (let i = 0; i < records.length; i++) {
      console.log('Record');
      console.log(records[i]);
      console.log(records[i].spent);
      if (!records[i].spent && Number(records[i].data.microcredits.slice(0, -11)) >= min_microcredits) {
        return records[i];
      }
    }

    return null;
  }

  const startNewGame = async () => {
    let payRecord = await getSpendableRecord(credit_records, 5000000);
    console.log('PayRecord');
    console.log(payRecord);
    if (payRecord) {
      const microcredits = Number(payRecord.data.microcredits.slice(0, -11)); 
      console.log('Microcredits: ', microcredits);
    } 
    else {
      throw NotEnoughCreditsException('Not enough credits on records');
    }

    const aleoTransaction = Transaction.createTransaction(
      publicKey,
      WalletAdapterNetwork.Testnet,
      'game2048_1elm7z.aleo',
      'init_game',
      [], 5000000
    );

    if (requestTransaction) {
      const result = await requestTransaction(aleoTransaction);
      dispatch(setLastTransaction({last_transaction: result}));
      console.log('Result');
      console.log(result);
      console.log('Last Transaction');
      console.log(last_transaction);
    }
  };

  return (
    <main className='col-4'>
      {publicKey ?
      <div>
        {current_game_records.length > 0 ? <GameSelect />
        : <div className='flex place-content-center'>
            { credit_records.length > 0 ? <div>
                <h2 className='text-white text-lg'>Sync your Game Records:</h2>
                <button className='flex justify-content-between btn btn-dark btn-lg border border-1 border-white rounded mt-5 w-100'
                onClick={loadGameRecords}>
                  <RefreshCcwDot size={32} /> Sync Records
                </button>
                <h2 className='text-white text-lg mt-5'>Or start a new game:</h2>
                <button className='flex justify-content-between btn btn-dark btn-lg border border-1 border-white rounded mt-5 w-100'
                onClick={startNewGame}>
                  <Play size={32} /> Start a Game
                </button>
              </div>
            : <div className='flex flex-column place-content-center'>
                <h2 className='text-white text-lg'>Sync your Credit Records:</h2>
                <button className='flex justify-content-between btn btn-dark btn-lg border border-1 border-white rounded mt-5 w-100'
                onClick={loadCreditRecords}>
                  <RefreshCcwDot size={32} /> Sync Records
                </button>
              </div>
            }
          </div>
        }
      </div>
      : <h1 className='text-white'>Connect your Leo Wallet</h1>
      }
    </main>
  );
}