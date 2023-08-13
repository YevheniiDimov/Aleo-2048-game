import styled from 'styled-components';

const TileColors = {
  0: '#c8cbbf',
  1: '#c8cbbf',
  2: '#65816d',
  3: '#65816d',
  4: '#334f3b',
  5: '#334f3b',
  6: '#072f37',
  7: '#072f37',
  8: '#bd7423',
  9: '#bd7423',
  10: '#AA1803',
  11: '#AA1803'
};

const Block = styled.div.attrs(props => ({
  color: props.color,
  text_color: props.text_color
}))`
    border-radius: 3px;
    border: 0px solid;
    background-color: ${props => props.color};
    color: ${props => props.text_color};
    display: flex;
    user-select: none;
`;

function Tile(props) {
  let block_color = TileColors[props.power];
  let text_color = props.power === 0 ? block_color : 'white';

  return (
    <Block color={block_color} text_color={text_color} className='col-3'>
      <h2 className='m-auto'>{props.power === 0 ? 0 : 2 ** props.power}</h2>
    </Block>
  );
}

export default Tile;