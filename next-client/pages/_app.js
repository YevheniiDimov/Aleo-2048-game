import { WalletProvider } from "@demox-labs/aleo-wallet-adapter-react";
import { LeoWalletAdapter } from "@demox-labs/aleo-wallet-adapter-leo";
import { WalletModalProvider } from "@demox-labs/aleo-wallet-adapter-reactui";
import { DecryptPermission, WalletAdapterNetwork } from "@demox-labs/aleo-wallet-adapter-base";
import { Hydrate, QueryClient, QueryClientProvider } from 'react-query';
import 'bootstrap/dist/css/bootstrap.min.css';
import Layout from "../components/Layout";
import { useMemo, useState } from "react";
import { Provider } from 'react-redux'
import store from '@/store/store';
import 'tailwindcss/tailwind.css';
import './app.css';

require("@demox-labs/aleo-wallet-adapter-reactui/styles.css");

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
              <Layout />
              <Component {...pageProps} />
            </Provider> 
          </WalletModalProvider>
        </WalletProvider>
      </Hydrate>
    </QueryClientProvider>
  );
}