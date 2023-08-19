import 'bootstrap/dist/css/bootstrap.min.css';
import Link from 'next/link';

export default function Home() {
  return (
    <main className='d-flex flex-column justify-content-center align-items-center col-4 my-5 mx-auto'>
      <h3 className='text-4xl'>Welcome to Aleo 2048 Game!</h3>
      <Link href='/game' className='mt-5 text-lg hover:text-blue'>Click here to Play</Link>
    </main>
  );
}