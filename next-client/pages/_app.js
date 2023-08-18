import { WalletProvider } from "@demox-labs/aleo-wallet-adapter-react";
import { WalletModalProvider } from "@demox-labs/aleo-wallet-adapter-reactui";
import { LeoWalletAdapter } from "@demox-labs/aleo-wallet-adapter-leo";
import { DecryptPermission, WalletAdapterNetwork } from "@demox-labs/aleo-wallet-adapter-base";
import { Hydrate, QueryClient, QueryClientProvider } from 'react-query';
import styled from 'styled-components';
import { WalletMultiButton } from '@demox-labs/aleo-wallet-adapter-reactui';
import { Provider } from 'react-redux'
import store from '@/store/store';
import { useMemo, useState } from "react";
import 'bootstrap/dist/css/bootstrap.min.css';
import 'tailwindcss/tailwind.css'
import './app.css';

require("@demox-labs/aleo-wallet-adapter-reactui/styles.css");

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

export default function App({ Component, pageProps }) {
  const wallets = useMemo(
    () => [
      new LeoWalletAdapter({
        appName: 'Leo Demo App',
      }),
    ],
    []
  );

  const [queryClient] = useState(() => new QueryClient());

  return (
    <QueryClientProvider client={queryClient}>
      <Hydrate state={pageProps.dehydratedState}>
        <WalletProvider
        wallets={wallets}
        decryptPermission={DecryptPermission.AutoDecrypt}
        network={WalletAdapterNetwork.Testnet}
        autoConnect>
          <WalletModalProvider>
            <Provider store={store}>
            <div className="App d-flex flex-column align-items-center bg-dark min-vh-100">
              <header className="d-flex align-items-center p-3 w-100">
                <h3 className='text-white text-2xl'>Aleo 2048</h3>
                <HeaderLink className='header-button pb-1 me-5 ms-auto'>About</HeaderLink>
                <WalletMultiButton className="bg-blue border-1 border rounded" />
              </header>
              <Component {...pageProps} />
            </div>
            </Provider> 
          </WalletModalProvider>
        </WalletProvider>
      </Hydrate>
    </QueryClientProvider>
  );
}