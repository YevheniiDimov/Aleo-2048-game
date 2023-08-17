import styled from 'styled-components';
import Grid from './Grid';

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
  const fill_data = [
    [0, 4, 8, 0],
    [4, 1, 5, 10],
    [0, 9, 2, 4],
    [11, 7, 4, 3]
  ];

  return (
    <div className="App d-flex flex-column align-items-center bg-dark vh-100">
        <header className="d-flex align-items-center p-3 w-100">
          <h3 className='text-white'>Aleo 2048</h3>
          <HeaderLink className='mx-5 header-button pb-1'>Your Account</HeaderLink>
        </header>
        <main className='col-4'>
          <h3 className='text-white'>Your score: 0</h3>
          <Grid tile_data={fill_data}/>
        </main>
    </div>
  );
}

export default Layout;