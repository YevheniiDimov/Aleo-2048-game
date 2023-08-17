'use client'
import styled from 'styled-components';
import Tile from './Tile';


const Canvas = styled.div`
  border-radius: 3px;
  height: 33.33vw;
`;

const Row = styled.div`
  height: 25%;
`;

function Grid(props) {
  return (
    <Canvas>
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
