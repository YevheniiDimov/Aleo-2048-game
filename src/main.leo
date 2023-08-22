// The 'game_2048' program.
program game_2048.aleo {
    // As Aleo import functionality is in active development and will
    // be changed in the future (not stable), as well as the imported
    // leo files have issues with importing inline functions, it was 
    // decided to put everything into one file, which is not a good
    // practice, but prevents the integration issues

    // As Aleo does not provide unit built-in testing functionality,
    // I will use the mixed approach of unit testing and manual
    // testing, using the transitions and inputs with changing different
    // patterns so I can emulate some of the game process whilst 
    // sticking to the validations of the smallest separate units

    // Initially I tried to use struct-oriented approach, as I was
    // experienced in the OOP before, but then after seeing the
    // battleship example I understood that I should use the binary
    // and mathematical approaches, so it will be more efficient and
    // readable. The logic is to create different record of board
    // states connecting to each other. The validation of those can
    // be traced on the blockchain, as if two states connect to the
    // one, only the most early one is valid. The board_states have
    // hash as own identificators, which help to create a snapshot
    // of a particular state for a particular player. If two states
    // are not valid because of the unrealistic outcome, it also
    // can be traced, so the cheating player can be identified

    // Player account structure, stores statistics
    // of the player which can be used for leaderboards
    struct Player {
      games_played: u64,
      games_won: u64,
      max_score: u64
    }

    mapping players: address => Player;

    // Describes a board state, stored as a
    // record which is directly connected to a
    // player and a previous state
    record board_state {
      owner: address,
      state_address: u128,
      prev_state_address: u128,
      board: u64,
      score: u64,
      points: u64,
      move: u16,
      game_state: u8 // 0 - started, 1 - in progress, 2 - pending tile, 3 - won, 4 - lost
    }

    struct MoveResult {
      board: u64,
      points: u64
    }

    struct GenerateTileResult {
      row: u64,
      generated: bool,
      index: u8,
      last_tile: u8
    }

    struct Sign64 {
      num: u64
    }

    struct Sign {
      sign0: u16,
      sign1: u16,
      sign2: u16
    }

    // Extracts row from the board by index (from right to left)
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

    // Extracts individual tiles from row (from left to right)
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

    // Extracts buffer (tiles without spacing) (from right to left)
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

      if (tile2 != 0u64) {
        if (tile3 != 0u64) {
          tile2 = tile2 << 4u8;
        }
      }

      if (tile1 != 0u64) {
        if (tile3 != 0u64) {
          if (tile2 != 0u64) {
            tile1 = tile1 << 8u8;
          } else { tile1 = tile1 << 4u8; }
        }
      }

      if (tile0 != 0u64) {
        if (tile3 != 0u64) {
          if (tile2 != 0u64) {
            if (tile1 != 0u64) {
              tile0 = tile0 << 12u8;
            } else { tile0 = tile0 << 8u8; }
          } else { tile0 = tile0 << 4u8; }
        }
      }

      return tile0 + tile1 + tile2 + tile3;
    }

    // Adds elements to buffer (to right)
    inline allocate_to_buffer_right(buffer: u64, tile: u64) -> u64 {
      let tile0: u64 = 61440u64;
      let tile1: u64 = 3840u64;
      let tile2: u64 = 240u64;
      let tile3: u64 = 15u64;

      tile0 = buffer & tile0;
      tile1 = buffer & tile1;
      tile2 = buffer & tile2;
      tile3 = buffer & tile3;

      tile2 = tile2 >> 4u8;
      tile1 = tile1 >> 8u8;
      tile0 = tile0 >> 12u8;

      if (tile3 == 0u64) { tile3 = tile; }
      else if (tile2 == 0u64) { tile2 = tile; }
      else if (tile1 == 0u64) { tile1 = tile; }
      else if (tile0 == 0u64) { tile0 = tile; }

      tile2 = tile2 << 4u8;
      tile1 = tile1 << 8u8;
      tile0 = tile0 << 12u8;

      return tile0 + tile1 + tile2 + tile3;
    }

    // Adds elements to buffer (to left)
    inline allocate_to_buffer_left(buffer: u64, tile: u64) -> u64 {
      let tile0: u64 = 61440u64;
      let tile1: u64 = 3840u64;
      let tile2: u64 = 240u64;
      let tile3: u64 = 15u64;

      tile0 = buffer & tile0;
      tile1 = buffer & tile1;
      tile2 = buffer & tile2;
      tile3 = buffer & tile3;

      tile2 = tile2 >> 4u8;
      tile1 = tile1 >> 8u8;
      tile0 = tile0 >> 12u8;

      if (tile0 == 0u64) { tile0 = tile; }
      else if (tile1 == 0u64) { tile1 = tile; }
      else if (tile2 == 0u64) { tile2 = tile; }
      else if (tile3 == 0u64) { tile3 = tile; }

      tile2 = tile2 << 4u8;
      tile1 = tile1 << 8u8;
      tile0 = tile0 << 12u8;

      return tile0 + tile1 + tile2 + tile3;
    }

    // Extracts a tile from a row using index beginning from right, also can be shifted by number of shift
    inline extract_tile(row: u64, index: u8, shift: u8) -> u64 {
      let mask: u64 = 15u64 * 16u64.pow(index);
      let tile: u64 = row & mask;  
      tile = tile >> 4u8.mul(index);
      return tile << shift;
    }

    // Sets a tile in a row by index (beginning from right)
    inline set_tile(row: u64, index: u8, tile: u64) -> u64 {
      let mask: u64 = 15u64 * 16u64.pow(index);
      let flipped_mask: u64 = 18446744073709551615u64 - mask;
      let empty: u64 = row & flipped_mask;
      tile = tile << 4u8.mul(index);
      return row + tile;
    }

    // Sets a row using index (beginning from the bottom of the board)
    inline set_row(board: u64, index: u8, row: u64) -> u64 {
      let mask: u64 = 65535u64 * 65536u64.pow(index);
      let flipped_mask: u64 = 18446744073709551615u64 - mask;
      let empty: u64 = row & flipped_mask;  
      row = row << 16u8.mul(index);
      return board + row;
    }

    // Flips the tiles to the left
    function flip_side(tiles: u64) -> u64 {
      let buffer: u64 = allocate_to_buffer_left(0u64, extract_tile(tiles, 3u8, 0u8));
      buffer = allocate_to_buffer_left(buffer, extract_tile(tiles, 2u8, 0u8));
      buffer = allocate_to_buffer_left(buffer, extract_tile(tiles, 1u8, 0u8));
      buffer = allocate_to_buffer_left(buffer, extract_tile(tiles, 0u8, 0u8));

      return buffer;
    }

    // Extracts column from the table by index, so the
    // top element of the board will be left-most and
    // bottom element of the board will be right-most
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

    // Moves tiles to right according to the
    // 2048 game logic
    function move_tiles_right(tiles: u64) -> MoveResult {
      if (tiles == 0u64) { return MoveResult { board: tiles, points: 0u64 }; } // Don't move if empty
      
      let tiles_buffer: u64 = extract_tiles_buffer(tiles);
      let tile0: u64 = extract_tile(tiles_buffer, 0u8, 0u8);
      let tile1: u64 = extract_tile(tiles_buffer, 1u8, 0u8);
      let tile2: u64 = extract_tile(tiles_buffer, 2u8, 0u8);
      let tile3: u64 = extract_tile(tiles_buffer, 3u8, 0u8);
      let buffer: u64 = 0u64;

      let tile_sum: u64 = 0u64;
      let points: u64 = 0u64;
        
      if (tile0 == tile1 && tile0 != 0u64) {
        buffer = allocate_to_buffer_right(buffer, tile0 + 1u64);
        tile_sum = tile0 + tile1;
        points = points + tile_sum;
        if (tile2 == tile3 && tile2 != 0u64) {
          tile_sum = tile2 + tile3;
          points = points + tile_sum;
          buffer = allocate_to_buffer_right(buffer, tile2 + 1u64);
        } else {
          buffer = allocate_to_buffer_right(buffer, tile2);
          buffer = allocate_to_buffer_right(buffer, tile3);
        }
      } else if (tile1 == tile2 && tile1 != 0u64) {
        tile_sum = tile1 + tile2;
        points = points + tile_sum;
        buffer = allocate_to_buffer_right(buffer, tile0);
        buffer = allocate_to_buffer_right(buffer, tile1 + 1u64);
        buffer = allocate_to_buffer_right(buffer, tile3);
      } else if (tile2 == tile3 && tile2 != 0u64) {
        tile_sum = tile2 + tile3;
        points = points + tile_sum;
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

    
    // Moves tiles to left according to the
    // 2048 game logic
    function move_tiles_left(tiles: u64) -> MoveResult {
      if (tiles == 0u64) { return MoveResult { board: tiles, points: 0u64 }; } // Don't move if empty

      let tiles_buffer: u64 = extract_tiles_buffer(tiles);
      let tile0: u64 = extract_tile(tiles_buffer, 0u8, 0u8);
      let tile1: u64 = extract_tile(tiles_buffer, 1u8, 0u8);
      let tile2: u64 = extract_tile(tiles_buffer, 2u8, 0u8);
      let tile3: u64 = extract_tile(tiles_buffer, 3u8, 0u8);
      let buffer: u64 = 0u64;
      
      let tile_sum: u64 = 0u64;
      let points: u64 = 0u64;
        
      if (tile3 == tile2 && tile3 != 0u64) {
        buffer = allocate_to_buffer_left(buffer, tile3 + 1u64);
        tile_sum = tile3 + tile2;
        points = points + tile_sum;
        if (tile1 == tile0 && tile1 != 0u64) {
          tile_sum = tile1 + tile0;
          points = points + tile_sum;
          buffer = allocate_to_buffer_left(buffer, tile1 + 1u64);
        } else {
          buffer = allocate_to_buffer_left(buffer, tile1);
          buffer = allocate_to_buffer_left(buffer, tile0);
        }
      } else if (tile2 == tile1 && tile2 != 0u64) {
        tile_sum = tile2 + tile1;
        points = points + tile_sum;
        buffer = allocate_to_buffer_left(buffer, tile3);
        buffer = allocate_to_buffer_left(buffer, tile2 + 1u64);
        buffer = allocate_to_buffer_left(buffer, tile0);
      } else if (tile1 == tile0 && tile1 != 0u64) {
        tile_sum = tile1 + tile0;
        points = points + tile_sum;
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

    
    // Converts cols back to rows (board)
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

    // Checking the winning condition
    function is_won(row0: u64, row1: u64, row2: u64, row3: u64) -> bool {
      return extract_tile(row0, 0u8, 0u8) == 11u64 || extract_tile(row0, 1u8, 0u8) == 11u64 || extract_tile(row0, 2u8, 0u8) == 11u64 || extract_tile(row0, 3u8, 0u8) == 11u64
      || extract_tile(row1, 0u8, 0u8) == 11u64 || extract_tile(row1, 1u8, 0u8) == 11u64 || extract_tile(row1, 2u8, 0u8) == 11u64 || extract_tile(row1, 3u8, 0u8) == 11u64
      || extract_tile(row2, 0u8, 0u8) == 11u64 || extract_tile(row2, 1u8, 0u8) == 11u64 || extract_tile(row2, 2u8, 0u8) == 11u64 || extract_tile(row2, 3u8, 0u8) == 11u64
      || extract_tile(row3, 0u8, 0u8) == 11u64 || extract_tile(row3, 1u8, 0u8) == 11u64 || extract_tile(row3, 2u8, 0u8) == 11u64 || extract_tile(row3, 3u8, 0u8) == 11u64;
    }

    // Check if the tiles are mergeable or empty (so it's not the losing position)
    function is_mergeable_or_empty(tiles: u64) -> bool {
      let tiles_buffer: u64 = extract_tiles_buffer(tiles);
      let tile0: u64 = extract_tile(tiles_buffer, 0u8, 0u8);
      let tile1: u64 = extract_tile(tiles_buffer, 1u8, 0u8);
      let tile2: u64 = extract_tile(tiles_buffer, 2u8, 0u8);
      let tile3: u64 = extract_tile(tiles_buffer, 3u8, 0u8);

      return tile0 == 0u64 || tile1 == 0u64 || tile2 == 0u64 || tile3 == 0u64 || (tile0 == tile1) || (tile1 == tile2) || (tile2 == tile3);
    }

    // Get a combined hash from board, player and salt
    function get_hash(board: u64, player: address, salt: u64) -> u128 {
      let hash0: u16 = Poseidon8::hash_to_u16(Sign64 {num: board});
      let hash1: u16 = Poseidon8::hash_to_u16(player);
      let hash2: u16 = Poseidon8::hash_to_u16(Sign64 {num: salt});
      
      return Poseidon8::hash_to_u128(Sign {sign0: hash0, sign1: hash1, sign2: hash2});
    }

    // Generate pseudonumber form hash and range, as random functions
    // work only in a finalize functions, putting restrictions on the code
    inline get_pseudorandom_number(hash: u64, upper: u64, lower: u64) -> u64 {
      return (hash % (upper - lower + 1u64)) + lower;
    }

    // Generates a new tile (2 or 4) in a row with some chance
    function generate_tile_row(row: u64, chance: u64, tile: u64, index: u8) -> GenerateTileResult {
      let tile0: u64 = extract_tile(row, 3u8, 0u8);
      let tile1: u64 = extract_tile(row, 2u8, 0u8);
      let tile2: u64 = extract_tile(row, 1u8, 0u8);
      let tile3: u64 = extract_tile(row, 0u8, 0u8);
      let generated: bool = false;
      let last_tile: u8 = 99u8;

      if (tile3 == 0u64) {last_tile = 3u8;}
      else if (tile2 == 0u64) {last_tile = 2u8;}
      else if (tile1 == 0u64) {last_tile = 1u8;}
      else if (tile0 == 0u64) {last_tile = 0u8;}

      if (tile0 == 0u64 && get_pseudorandom_number(Poseidon8::hash_to_u64(tile0 + chance), 10u64, 0u64) < chance) { tile0 = tile; generated = true; }
      else if (tile2 == 0u64 && get_pseudorandom_number(Poseidon8::hash_to_u64(tile2 + chance), 10u64, 0u64) < chance) { tile2 = tile; generated = true; }
      else if (tile1 == 0u64 && get_pseudorandom_number(Poseidon8::hash_to_u64(tile1 + chance), 10u64, 0u64) < chance) { tile1 = tile; generated = true; }
      else if (tile3 == 0u64 && get_pseudorandom_number(Poseidon8::hash_to_u64(tile3 + chance), 10u64, 0u64) < chance) { tile3 = tile; generated = true; }

      tile0 = tile0 << 12u8;
      tile1 = tile1 << 8u8;
      tile2 = tile2 << 4u8;

      return GenerateTileResult { row: tile0 + tile1 + tile2 + tile3, generated: generated, index: index, last_tile: last_tile };
    }
    
    // Generates a tile using a board state with a finished movement
    // so it returns the state with the updated board and a new tile
    transition generate_tile(board: board_state) -> board_state {
      assert(board.game_state == 2u8); // Board state should be pending a tile
      let tile: u64 = 1u64;
      if (board.move % 10u16 == 0u16) { tile = 2u64; } // Get 2 every tenth move (10% chance simulation)

      let chance: u64 = get_pseudorandom_number(Poseidon8::hash_to_u64(board), 10u64, 0u64);

      let index: field = 0field;
      let generated: bool = false;
      let last_tile: u8 = 99u8;
      let last_row: field = 99field;
      let generated_row: GenerateTileResult = GenerateTileResult {row: 0u64, generated: false, index: 99u8, last_tile: 99u8};
      
      let new_board: u64 = 0u64;
      for i: u8 in 0u8..4u8 {
        if (!generated) {
          let row: GenerateTileResult = generate_tile_row(extract_row(board.board, index), chance, tile, index as u8);

          if (row.generated) { 
            generated = row.generated;
            generated_row = row; 
          } else if (row.last_tile != 99u8) {
            last_tile = row.last_tile;
            last_row = index;
          }

          index += 1field;
        }
      }

      if (generated) {
        new_board = set_row(board.board, generated_row.index, generated_row.row);
      }
      else {
        let new_row: u64 = extract_row(board.board, last_row);
        new_row = set_tile(new_row, last_tile, tile);
        new_board = set_row(board.board, last_row as u8, new_row);
      }

      return board_state {
        owner: board.owner,
        board: new_board,
        state_address: get_hash(new_board, board.owner, new_board.sub_wrapped(board.score)),
        prev_state_address: board.state_address,
        score: board.score,
        points: board.points,
        move: board.move,
        game_state: 1u8
      };
    }

    transition generate_tile_row_test() -> GenerateTileResult {
      return generate_tile_row(37280u64, 10u64, 1u64, 0u8); // 37024
    }

    transition pseudonumber_test() -> u64 {
      return get_pseudorandom_number(45782136139006u64, 10u64, 0u64);
    }

    transition set_row_test(board: u64, index: u8, row: u64) -> u64 {
      return set_row(board, index, row);
    }

    transition set_tile_test(row: u64, index: u8, tile: u64) -> u64 {
      return set_tile(row, index, tile);
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

    transition buffer_left() -> u64 {
        return allocate_to_buffer_left(63072u64, 5u64);
    }

    transition get_tiles_left(tiles: u64) -> MoveResult {
        return move_tiles_left(tiles);
    }

    transition get_tiles_right(tiles: u64) ->  MoveResult {
        return move_tiles_right(tiles);
    }

    // Creates a new game for a player to play
    transition init_game() -> board_state {
      return board_state {
        owner: self.caller,
        board: 0u64,
        state_address: get_hash(0u64, self.caller, 6u64),
        prev_state_address: 0u128,
        score: 0u64,
        points: 0u64,
        move: 6u16,
        game_state: 0u8
      } then finalize(self.caller);
    }

    finalize init_game(caller: address) {
      let player: Player = Mapping::get_or_use(players, caller, Player {games_played: 0u64, games_won: 0u64, max_score: 0u64});
      if (player.games_played == 0u64) {
        Mapping::set(players, caller, Player {games_played: 1u64, games_won: 0u64, max_score: 0u64});
      } else {
        Mapping::set(players, caller, Player {games_played: player.games_played + 1u64, games_won: 0u64, max_score: 0u64});
      }
    }

    // Moves a board to some direction according
    // to the 2048 game logic returning a state
    // with the updated board after movement
    // Side: 0 - top, 1 - right, 2 - bottom, 3 - left 
    transition move(board: board_state, side: u8) -> board_state {
      assert(board.owner == self.caller); // Check if the caller is the state owner
      assert(board.game_state < 2u8); // Check if the game is not finished and has a new tile
      let opposite: bool = side == 2u8 || side == 3u8;
      let new_board: u64 = 0u64;
      let game_state: u8 = 2u8;
      let points: u64 = 0u64;

      if (board.board != 0u64) {
        if (side == 0u8 || side == 2u8) { // top or bottom
          let col0: MoveResult = side == 0u8 ? move_tiles_left(extract_column(board.board, 3u8)) : move_tiles_right(extract_column(board.board, 3u8));
          let col1: MoveResult = side == 0u8 ? move_tiles_left(extract_column(board.board, 2u8)) : move_tiles_right(extract_column(board.board, 2u8));
          let col2: MoveResult = side == 0u8 ? move_tiles_left(extract_column(board.board, 1u8)) : move_tiles_right(extract_column(board.board, 1u8));
          let col3: MoveResult = side == 0u8 ? move_tiles_left(extract_column(board.board, 0u8)) : move_tiles_right(extract_column(board.board, 0u8));

          points = col0.points + col1.points + col2.points + col3.points;
          new_board = cols_to_rows(col0.board, col1.board, col2.board, col3.board);

          if (is_won(col0.board, col1.board, col2.board, col3.board)) { game_state = 3u8; }
          else {
            let row0: u64 = extract_row(new_board, 3field);
            let row1: u64 = extract_row(new_board, 2field);
            let row2: u64 = extract_row(new_board, 1field);
            let row3: u64 = extract_row(new_board, 0field);

            let is_movable: bool = is_mergeable_or_empty(col0.board) || is_mergeable_or_empty(col1.board)
            || is_mergeable_or_empty(col2.board) || is_mergeable_or_empty(col3.board) ||
            is_mergeable_or_empty(row0) || is_mergeable_or_empty(row1)
            || is_mergeable_or_empty(row2) || is_mergeable_or_empty(row3);

            if (!is_movable) { game_state = 4u8; }
          }
        } else { // right or left
          let row0: MoveResult = side == 1u8 ? move_tiles_right(extract_row(board.board, 3field)) : move_tiles_left(extract_row(board.board, 3field));
          let row1: MoveResult = side == 1u8 ? move_tiles_right(extract_row(board.board, 2field)) : move_tiles_left(extract_row(board.board, 2field));
          let row2: MoveResult = side == 1u8 ? move_tiles_right(extract_row(board.board, 1field)) : move_tiles_left(extract_row(board.board, 1field));
          let row3: MoveResult = side == 1u8 ? move_tiles_right(extract_row(board.board, 0field)) : move_tiles_left(extract_row(board.board, 0field));

          points = row0.points + row1.points + row2.points + row3.points;

          let row2_shifted: u64 = row2.board << 16u8;
          let row1_shifted: u64 = row1.board << 32u8;
          let row0_shifted: u64 = row0.board << 48u8;
          new_board = row3.board + row2_shifted + row1_shifted + row0_shifted;

          if (is_won(row0.board, row1.board, row2.board, row3.board)) { game_state = 3u8; }
          else {
            let col0: u64 = extract_column(new_board, 3u8);
            let col1: u64 = extract_column(new_board, 2u8);
            let col2: u64 = extract_column(new_board, 1u8);
            let col3: u64 = extract_column(new_board, 0u8);

            let is_movable: bool = is_mergeable_or_empty(col0) || is_mergeable_or_empty(col1)
            || is_mergeable_or_empty(col2) || is_mergeable_or_empty(col3) ||
            is_mergeable_or_empty(row0.board) || is_mergeable_or_empty(row1.board)
            || is_mergeable_or_empty(row2.board) || is_mergeable_or_empty(row3.board);

            if (!is_movable) { game_state = 4u8; }
          }
        }

        assert(new_board != board.board); // Check if the movement is valid
      }

      return board_state {
        owner: board.owner,
        board: new_board,
        state_address: get_hash(new_board, board.owner, new_board.sub_wrapped(points)),
        prev_state_address: board.state_address,
        score: board.score + points,
        points: points,
        move: board.move + 1u16,
        game_state: game_state
      } then finalize(board.owner, board.score + points, game_state);
    }

    finalize move(caller: address, score: u64, game_state: u8) {
      let player: Player = Mapping::get_or_use(players, caller, Player {games_played: 0u64, games_won: 0u64, max_score: 9999999999u64});
      let new_score: u64 = player.max_score;
      if (score > player.max_score) { new_score = score; }
      assert(player.max_score < 9999999999u64); // Check if player exists
      if (game_state == 3u8) { // Won
        Mapping::set(players, caller, Player {games_played: player.games_played, games_won: player.games_won + 1u64, max_score: new_score});
      } else { // Lost or in progress
        Mapping::set(players, caller, Player {games_played: player.games_played, games_won: player.games_won, max_score: new_score});
      }
    }

    transition row_move_test() -> (u64, u64, u64, u64) {
      let board: u64 = 1152921504606846976u64;
      let row0: MoveResult = move_tiles_right(extract_row(board, 3field));
      let row1: MoveResult = move_tiles_right(extract_row(board, 2field));
      let row2: MoveResult = move_tiles_right(extract_row(board, 1field));
      let row3: MoveResult = move_tiles_right(extract_row(board, 0field));

      let row2_shifted: u64 = row2.board << 16u8;
      let row1_shifted: u64 = row1.board << 32u8;
      let row0_shifted: u64 = row0.board << 48u8;
      return (row0_shifted, row1_shifted, row2_shifted, row3.board);
    }

    transition generate_tile_row_test() -> GenerateTileResult {
      return generate_tile_row(4097u64, 10u64, 1u64, 3u8);
    }

    transition right_buffer_test() -> u64 {
      let tiles_buffer: u64 = extract_tiles_buffer(4097u64);
      return tiles_buffer;
    }

    transition win_condition_test(board: u64) -> bool {
      let row0: u64 = extract_row(board, 3field);
      let row1: u64 = extract_row(board, 2field);
      let row2: u64 = extract_row(board, 1field);
      let row3: u64 = extract_row(board, 0field);

      return is_won(row0, row1, row2, row3);
    }

    transition lose_condition_test(board: u64) -> bool {
      for i: u8 in 0u8..4u8 {
         let col: u64 = extract_column(board, i);
         if (is_mergeable_or_empty(col)) {
          return false;
         }
      }

      let index: field = 0field;
      for i: u8 in 0u8..4u8 {
         let row: u64 = extract_row(board, index);
         if (is_mergeable_or_empty(row)) {
          return false;
         }

         index += 1field;
      }

      return true;
    }
}