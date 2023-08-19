import { WalletMultiButton } from '@demox-labs/aleo-wallet-adapter-reactui';
import { useWallet } from "@demox-labs/aleo-wallet-adapter-react";
import * as Popover from '@radix-ui/react-popover';
import { useState, useEffect } from "react";
import styled from 'styled-components';
import Link from 'next/link';

const HeaderLink = styled.div`
  font-size: 1.25em;
  font-weight: bolder;
  color: white;
  opacity: 50%;
  transition: 0.1s ease-in;

  &:hover {
    opacity: 100%;
    cursor: pointer;
  }
`;

function Layout() {
  const [account, setAccount] = useState(null);
  const { publicKey } = useWallet();

  useEffect(() => {
    if (publicKey) {
      const url = `https://vm.aleo.org/api/testnet3/program/game2048_1elm7z.aleo/mapping/players/${publicKey}`;
      fetch(url).then(response => response.text())
      .then(response => {
        let response_text = response.replace(/\\n/g, '')
        .replace(/u64/g, '').replace(/ /g, '')
        .replace(/games_played/g, '\\"games_played\\"')
        .replace(/games_won/g, '\\"games_won\\"')
        .replace(/max_score/g, '\\"max_score\\"');
        try {
          setAccount(JSON.parse(response_text));
        }
        catch {
          setAccount({games_played: 0, games_won: 0, max_score: 0});
        }
      });
    }
  }, [publicKey]);

  return (
    <div className="App d-flex flex-column align-items-center bg-dark">
      <header className="d-flex align-items-center px-3 w-100">
        <h3 className='text-white text-2xl'>Aleo 2048</h3>
        <div className='pb-1 me-5 ms-auto'>
          <Popover.Root className='mx-5'>
            <Popover.Trigger className='text-white'>Account</Popover.Trigger>
            <Popover.Portal>
              <Popover.Content className='text-white'>
                { account 
                ? <div>
                    <p className='text-white bg-dark p-2 rounded-top-1'>Games Played: {account.games_played}</p>
                    <p className='text-white bg-dark p-2'>Games Won: {account.games_won}</p>
                    <p className='text-white bg-dark p-2 rounded-bottom-1'>Max Score: {account.max_score}</p>
                  </div>
                : <p className='text-white'>Loading...</p>
                }
                <Popover.Arrow />
              </Popover.Content>
            </Popover.Portal>
          </Popover.Root>
        </div>
        <WalletMultiButton className="m-1" />
      </header>
    </div>
  );
}

export default Layout;