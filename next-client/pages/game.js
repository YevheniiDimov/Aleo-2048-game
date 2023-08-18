'use client'
import Grid from '@/components/Grid';
import { WalletNotConnectedError } from "@demox-labs/aleo-wallet-adapter-base";
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import { RefreshCcwDot } from 'lucide-react';
import { useState } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';

export default function Game() {
  const { records, setRecords } = useState([]);
  const { publicKey, requestRecords } = useWallet();

  const loadRecords = async () => {
    const program = "game2048_1elm7z.aleo";
    if (!publicKey) throw new WalletNotConnectedError();
    if (requestRecords) {
      const records = await requestRecords(program);
      console.log("Records: " + records);
      setRecords(records);
    }
  };

  const startNewGame = async () => {
    const program = "game2048_1elm7z.aleo";
    if (!publicKey) throw new WalletNotConnectedError();
    if (requestRecords) {
      const records = await requestRecords(program);
      console.log("Records: " + records);
      setRecords(records);
    }
  };

  const fill_data = [
    [0, 4, 8, 0],
    [4, 1, 5, 10],
    [0, 9, 2, 4],
    [11, 7, 4, 3]
  ];

  return (
    <main className='col-4'>
      {publicKey ?
      <div>
        {records ?
          <div>
            <h3 className='text-white'>Your score: 0</h3>
            <Grid tile_data={fill_data}/>
          </div>
        : <div className='text-center'>
            <h2 className='text-white'>Sync your Game Records:</h2>
            <button className='btn btn-dark btn-lg border border-1 border-white rounded mt-5 w-50'
            onClick={loadRecords}>
              <RefreshCcwDot size={32} /> Sync Records
            </button>
            <h2 className='text-white mt-5'>Or start a new game:</h2>
            <button className='btn btn-dark btn-lg border border-1 border-white rounded mt-5 w-50'
            onClick={startNewGame}>
              <RefreshCcwDot size={32} /> Sync Records
            </button>
          </div>
        }
      </div>
      : <h1 className='text-white'>Connect your Leo Wallet</h1>
      }
    </main>
  );
}