program helloworld.aleo {
    record board_state {
      owner: address,
      state_address: u128,
      prev_state_address: u128,
      board: u64,
      score: u64,
      points: u64,
      game_state: u8
    }

    struct MoveResult {
      board: u64,
      points: u64
    }

    struct MoveSign {
      board: u64,
      prev_state_address: u128,
      points: u64,
      side: u8,
      player: address,
      salt: u64
    }

    inline extract_row(board: u64, index: field) -> u64 {
        let row3_mask: u64 = 65535u64;
        let row2_mask: u64 = 4294901760u64;
        let row1_mask: u64 = 281470681743360u64;
        let row0_mask: u64 = 18446462598732840960u64;
        let row: u64 = board;

        if (index == 0field) {row &= row3_mask;}
        else if (index == 1field) {row &= row2_mask;}
        else if (index == 2field) {row &= row1_mask;}
        else {row &= row0_mask;}

        let shift_mask: u16 = (index * 16field) as u16;
        row = row >> shift_mask;

        return row;
    }

    inline extract_tiles(row: u64) -> (u64, u64, u64, u64) {
      let tile0: u64 = 61440u64;
      let tile1: u64 = 3840u64;
      let tile2: u64 = 240u64;
      let tile3: u64 = 15u64;

      tile0 = row & tile0;
      tile1 = row & tile1;
      tile2 = row & tile2;
      tile3 = row & tile3;

      tile0 = tile0 >> 12u8;
      tile1 = tile1 >> 8u8;
      tile2 = tile2 >> 4u8;

      return (tile0, tile1, tile2, tile3);
    }

    inline extract_tiles_buffer(tiles: u64) -> u64 {
      let tile0: u64 = 61440u64;
      let tile1: u64 = 3840u64;
      let tile2: u64 = 240u64;
      let tile3: u64 = 15u64;

      tile0 = tiles & tile0;
      tile1 = tiles & tile1;
      tile2 = tiles & tile2;
      tile3 = tiles & tile3;

      tile0 = tile0 >> 12u8;
      tile1 = tile1 >> 8u8;
      tile2 = tile2 >> 4u8;

      let buffer: u64 = 0u64;
      let tile_counter: u8 = 0u8;
      let shift: u64 = 0u64;

      if (tile3 != 0u64) {
        buffer += tile3;
        tile_counter += 1u8;
      }
      if (tile2 != 0u64) {
        shift = tile2 << 4u8.mul(tile_counter);
        buffer += shift;
        tile_counter += 1u8;
      }
      if (tile1 != 0u64) {
        shift = tile1 << 4u8.mul(tile_counter);
        buffer += shift;
        tile_counter += 1u8;
      }
      if (tile0 != 0u64) {
        shift = tile0 << 4u8.mul(tile_counter);
        buffer += shift;
      }

      return buffer;
    }

    inline allocate_to_buffer_right(buffer: u64, tile: u64) -> u64 {
      let tile0: u64 = 61440u64;
      let tile1: u64 = 3840u64;
      let tile2: u64 = 240u64;
      let tile3: u64 = 15u64;

      tile0 = buffer & tile0;
      tile1 = buffer & tile1;
      tile2 = buffer & tile2;
      tile3 = buffer & tile3;

      tile0 = tile0 >> 12u8;
      tile1 = tile1 >> 8u8;
      tile2 = tile2 >> 4u8;

      if (tile0 == 0u64) { tile0 = tile; }
      else if (tile1 == 0u64) { tile1 = tile; }
      else if (tile2 == 0u64) { tile2 = tile; }
      else if (tile3 == 0u64) { tile3 = tile; }

      tile1 = tile1 << 4u8;
      tile2 = tile2 << 8u8;
      tile3 = tile3 << 12u8;

      return tile0 + tile1 + tile2 + tile3;
    }

    inline allocate_to_buffer_left(buffer: u64, tile: u64) -> u64 {
      let tile0: u64 = 61440u64;
      let tile1: u64 = 3840u64;
      let tile2: u64 = 240u64;
      let tile3: u64 = 15u64;

      tile0 = buffer & tile0;
      tile1 = buffer & tile1;
      tile2 = buffer & tile2;
      tile3 = buffer & tile3;

      tile0 = tile0 >> 12u8;
      tile1 = tile1 >> 8u8;
      tile2 = tile2 >> 4u8;

      if (tile3 == 0u64) { tile3 = tile; }
      else if (tile2 == 0u64) { tile2 = tile; }
      else if (tile1 == 0u64) { tile1 = tile; }
      else if (tile0 == 0u64) { tile0 = tile; }

      tile1 = tile1 << 4u8;
      tile2 = tile2 << 8u8;
      tile3 = tile3 << 12u8;

      return tile0 + tile1 + tile2 + tile3;
    }

    inline extract_tile(row: u64, index: u8, shift: u8) -> u64 {
      let mask: u64 = 15u64 * 16u64.pow(index);
      let tile: u64 = row & mask;  
      tile = tile >> 4u8.mul(index);
      return tile << shift;
    }

    function flip_side(tiles: u64) -> u64 {
      let buffer: u64 = allocate_to_buffer_left(0u64, extract_tile(tiles, 3u8, 0u8));
      buffer = allocate_to_buffer_left(buffer, extract_tile(tiles, 2u8, 0u8));
      buffer = allocate_to_buffer_left(buffer, extract_tile(tiles, 1u8, 0u8));
      buffer = allocate_to_buffer_left(buffer, extract_tile(tiles, 0u8, 0u8));

      return buffer;
    }

    function extract_column(board: u64, index: u8) -> u64 {
        let row0: u64 = extract_row(board, 3field);
        let row1: u64 = extract_row(board, 2field);
        let row2: u64 = extract_row(board, 1field);
        let row3: u64 = extract_row(board, 0field);

        let col: u64 = 0u64;

        col += extract_tile(row3, index, 0u8);
        col += extract_tile(row2, index, 4u8);
        col += extract_tile(row1, index, 8u8);
        col += extract_tile(row0, index, 12u8);

        return col;
    }

    function move_tiles_right(tiles: u64) -> MoveResult {
      let tile0: u64 = extract_tile(tiles, 0u8, 0u8);
      let tile1: u64 = extract_tile(tiles, 1u8, 0u8);
      let tile2: u64 = extract_tile(tiles, 2u8, 0u8);
      let tile3: u64 = extract_tile(tiles, 3u8, 0u8);
      let buffer: u64 = 0u64;
      let points: u64 = 0u64;
        
      if (tile0 == tile1) {
        buffer = allocate_to_buffer_right(buffer, tile0 + 1u64);
        points += tile0 + tile1;
        if (tile2 == tile3) {
          points += tile2 + tile3;
          buffer = allocate_to_buffer_right(buffer, tile2 + 1u64);
        } else {
          buffer = allocate_to_buffer_right(buffer, tile2);
          buffer = allocate_to_buffer_right(buffer, tile3);
        }
      } else if (tile1 == tile2) {
        points += tile1 + tile2;
        buffer = allocate_to_buffer_right(buffer, tile0);
        buffer = allocate_to_buffer_right(buffer, tile1 + 1u64);
        buffer = allocate_to_buffer_right(buffer, tile3);
      } else if (tile2 == tile3) {
        points += tile2 + tile3;
        buffer = allocate_to_buffer_right(buffer, tile0);
        buffer = allocate_to_buffer_right(buffer, tile1);
        buffer = allocate_to_buffer_right(buffer, tile2 + 1u64);
      } else {
        buffer = allocate_to_buffer_right(buffer, tile0);
        buffer = allocate_to_buffer_right(buffer, tile1);
        buffer = allocate_to_buffer_right(buffer, tile2);
        buffer = allocate_to_buffer_right(buffer, tile3);
      }

      return MoveResult { board: buffer, points: points };
    }

    function move_tiles_left(tiles: u64) -> MoveResult {
      let tile0: u64 = extract_tile(tiles, 0u8, 0u8);
      let tile1: u64 = extract_tile(tiles, 1u8, 0u8);
      let tile2: u64 = extract_tile(tiles, 2u8, 0u8);
      let tile3: u64 = extract_tile(tiles, 3u8, 0u8);
      let buffer: u64 = 0u64;
      let points: u64 = 0u64;
        
      if (tile3 == tile2) {
        buffer = allocate_to_buffer_left(buffer, tile3 + 1u64);
        points += tile3 + tile2;
        if (tile1 == tile0) {
          points += tile1 + tile0;
          buffer = allocate_to_buffer_left(buffer, tile1 + 1u64);
        } else {
          buffer = allocate_to_buffer_left(buffer, tile1);
          buffer = allocate_to_buffer_left(buffer, tile0);
        }
      } else if (tile2 == tile1) {
        points += tile2 + tile1;
        buffer = allocate_to_buffer_left(buffer, tile3);
        buffer = allocate_to_buffer_left(buffer, tile2 + 1u64);
        buffer = allocate_to_buffer_left(buffer, tile0);
      } else if (tile1 == tile0) {
        points += tile1 + tile0;
        buffer = allocate_to_buffer_left(buffer, tile3);
        buffer = allocate_to_buffer_left(buffer, tile2);
        buffer = allocate_to_buffer_left(buffer, tile1 + 1u64);
      } else {
        buffer = allocate_to_buffer_left(buffer, tile3);
        buffer = allocate_to_buffer_left(buffer, tile2);
        buffer = allocate_to_buffer_left(buffer, tile1);
        buffer = allocate_to_buffer_left(buffer, tile0);
      }

      return MoveResult { board: buffer, points: points };
    }

    function cols_to_rows(col0: u64, col1: u64, col2: u64, col3: u64) -> u64 {
      let row0: u64 = extract_tile(col0, 3u8, 12u8);
      let row1: u64 = extract_tile(col0, 2u8, 12u8);
      let row2: u64 = extract_tile(col0, 1u8, 12u8);
      let row3: u64 = extract_tile(col0, 0u8, 12u8);

      row0 += extract_tile(col1, 3u8, 8u8);
      row1 += extract_tile(col1, 2u8, 8u8);
      row2 += extract_tile(col1, 1u8, 8u8);
      row3 += extract_tile(col1, 0u8, 8u8);

      row0 += extract_tile(col2, 3u8, 4u8);
      row1 += extract_tile(col2, 2u8, 4u8);
      row2 += extract_tile(col2, 1u8, 4u8);
      row3 += extract_tile(col2, 0u8, 4u8);

      row0 += extract_tile(col3, 3u8, 0u8);
      row1 += extract_tile(col3, 2u8, 0u8);
      row2 += extract_tile(col3, 1u8, 0u8);
      row3 += extract_tile(col3, 0u8, 0u8);

      row2 = row2 << 16u8;
      row1 = row1 << 32u8;
      row0 = row0 << 48u8;

      return row3 + row2 + row1 + row0;
    }

    transition get_col(board: u64, index: u8) -> u64 {
        return extract_column(board, index);
    }

    transition get_row(board: u64, index: field) -> u64 {
        return extract_row(board, index);
    }

    transition get_tiles(board: u64) -> (u64, u64, u64, u64) {
        let row: u64 = extract_row(board, 3field);
        let tiles: (u64, u64, u64, u64) = extract_tiles(row);
        return tiles;
    }

    transition get_buffer(tiles: u64) -> u64 {
        return extract_tiles_buffer(tiles);
    }

    transition get_tiles_left(tiles: u64) -> MoveResult {
        return move_tiles_left(tiles);
    }

    transition get_tiles_right(tiles: u64) ->  MoveResult {
        return move_tiles_right(tiles);
    }

    // Side: 0 - top, 1 - right, 2 - bottom, 3 - left
    transition move(board: board_state, side: u8) -> board_state {
      assert(board.owner == self.caller); // Check if the caller is the state owner
      let opposite: bool = side == 2u8 || side == 3u8;
      let new_board: u64 = 0u64;
      let points: u64 = 0u64;

      if (side == 0u8) { // top
        let col0: MoveResult = move_tiles_left(extract_tiles_buffer(extract_column(board.board, 3u8)));
        let col1: MoveResult = move_tiles_left(extract_tiles_buffer(extract_column(board.board, 2u8)));
        let col2: MoveResult = move_tiles_left(extract_tiles_buffer(extract_column(board.board, 1u8)));
        let col3: MoveResult = move_tiles_left(extract_tiles_buffer(extract_column(board.board, 0u8)));
    
        points = col0.points + col1.points + col2.points + col3.points;
        new_board = cols_to_rows(col0.board, col1.board, col2.board, col3.board);
      } else if (side == 2u8) { // bottom
        let col0: MoveResult = move_tiles_right(extract_tiles_buffer(extract_column(board.board, 3u8)));
        let col1: MoveResult = move_tiles_right(extract_tiles_buffer(extract_column(board.board, 2u8)));
        let col2: MoveResult = move_tiles_right(extract_tiles_buffer(extract_column(board.board, 1u8)));
        let col3: MoveResult = move_tiles_right(extract_tiles_buffer(extract_column(board.board, 0u8)));
    
        points = col0.points + col1.points + col2.points + col3.points;
        new_board = cols_to_rows(col0.board, col1.board, col2.board, col3.board);
      } else if (side == 1u8) { // right
        let row0: MoveResult = move_tiles_right(extract_tiles_buffer(extract_row(board.board, 3field)));
        let row1: MoveResult = move_tiles_right(extract_tiles_buffer(extract_row(board.board, 2field)));
        let row2: MoveResult = move_tiles_right(extract_tiles_buffer(extract_row(board.board, 1field)));
        let row3: MoveResult = move_tiles_right(extract_tiles_buffer(extract_row(board.board, 0field)));

        points = row0.points + row1.points + row2.points + row3.points;

        let row2_shifted: u64 = row2.board << 16u8;
        let row1_shifted: u64 = row2.board << 32u8;
        let row0_shifted: u64 = row2.board << 48u8;
        new_board = row3.board + row2_shifted + row1_shifted + row0_shifted;
      } else { // left
        let row0: MoveResult = move_tiles_left(extract_tiles_buffer(extract_row(board.board, 3field)));
        let row1: MoveResult = move_tiles_left(extract_tiles_buffer(extract_row(board.board, 2field)));
        let row2: MoveResult = move_tiles_left(extract_tiles_buffer(extract_row(board.board, 1field)));
        let row3: MoveResult = move_tiles_left(extract_tiles_buffer(extract_row(board.board, 0field)));

        points = row0.points + row1.points + row2.points + row3.points;

        let row2_shifted: u64 = row2.board << 16u8;
        let row1_shifted: u64 = row2.board << 32u8;
        let row0_shifted: u64 = row2.board << 48u8;
        new_board = row3.board + row2_shifted + row1_shifted + row0_shifted;
      }

      assert(new_board != board.board); // Check if the movement is valid

      let sign: MoveSign = MoveSign { board: new_board, prev_state_address: board.state_address, points: points, side: side, player: self.caller, salt: new_board.sub_wrapped(points)};
      return board_state {
        owner: board.owner,
        board: new_board,
        state_address: Pedersen128::hash_to_u128(sign),
        prev_state_address: board.state_address,
        score: board.score + points,
        points: points,
        game_state: 1u8
      };
    }
}