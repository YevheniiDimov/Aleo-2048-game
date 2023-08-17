'use client'
import styled from 'styled-components';
import { useSelector, useDispatch } from 'react-redux'
import { decrement, increment } from '@/store/gridSlice';
import Tile from './Tile';


const Canvas = styled.div`
  border-radius: 3px;
  height: 33.33vw;
`;

const Row = styled.div`
  height: 25%;
`;

function Grid(props) {
  const count = useSelector(state => state.grid.value);
  const dispatch = useDispatch();
  return (
    <Canvas>
        <button
          aria-label="Increment value"
          onClick={() => dispatch(increment())}
        >
          Increment</button>
          <button
          aria-label="Decrement value"
          onClick={() => dispatch(decrement())}
        >
          Decrement
        </button>
        <h1>Value: {count}</h1>
        {props.tile_data.map((row, i) => {
          return <Row className='row' key={i}>
            {row.map((tile, j) => 
              <Tile power={tile} key={(i, j)}/>
            )}
          </Row>
        })}
    </Canvas>
  );
}

export default Grid;
