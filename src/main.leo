// The 'game_2048' program.
program game_2048.aleo {
    // Point class represents a single tile
    struct Point {
        x: u8,
        y: u8,
        val: u16
    }

    // Row class represents 4 tiles of a board
    struct Row {
        p0: Point,
        p1: Point,
        p2: Point,
        p3: Point,
    }

    struct Buffer {
        v0: u16,
        v1: u16,
        v2: u16,
        v3: u16,
    }

    // Board for the game consists of 4 rows
    // This way making a matrix of 4x4 tiles
    struct Board {
        r0: Row,
        r1: Row,
        r2: Row,
        r3: Row,
    }

    // Game session for the player which is
    // stored in the mapping for all users
    struct Game {
        board: Board,
        score: u16,
        status: u8 // 0 - in play, 1 - won, 2 - lost
    }

    // As Leo doesn't support normal arrays by
    // default, there is a need to normalize
    // the syntax by making the helper functions
    // (But they don't look nice either)
    //------------------------------------------------------------
    inline create_empty_board() -> Board {
        return Board {
            r0: Row {p0: Point {x: 0u8, y: 0u8, val: 0u16}, p1: Point {x: 1u8, y: 0u8, val: 0u16}, p2: Point {x: 2u8, y: 0u8, val: 0u16}, p3: Point {x: 3u8, y: 0u8, val: 0u16}},
            r1: Row {p0: Point {x: 0u8, y: 1u8, val: 0u16}, p1: Point {x: 1u8, y: 1u8, val: 0u16}, p2: Point {x: 2u8, y: 1u8, val: 0u16}, p3: Point {x: 3u8, y: 1u8, val: 0u16}},
            r2: Row {p0: Point {x: 0u8, y: 2u8, val: 0u16}, p1: Point {x: 1u8, y: 2u8, val: 0u16}, p2: Point {x: 2u8, y: 2u8, val: 0u16}, p3: Point {x: 3u8, y: 2u8, val: 0u16}},
            r3: Row {p0: Point {x: 0u8, y: 3u8, val: 0u16}, p1: Point {x: 1u8, y: 3u8, val: 0u16}, p2: Point {x: 2u8, y: 3u8, val: 0u16}, p3: Point {x: 3u8, y: 3u8, val: 0u16}}
        };
    }

    function create_empty_game(score: u16) -> Game {
        return Game { board: create_empty_board(), score: score, status: 0u8};
    }

    inline get_row_by_index(board: Board, index: u8) -> Row {
        if (index == 0u8) {
            return board.r0;
        } else if (index == 1u8) {
            return board.r1;
        } else if (index == 2u8) {
            return board.r2;
        }
        
        return board.r3;
    }

    inline get_point_by_index(row: Row, index: u8) -> Point {
        if (index == 0u8) {
            return row.p0;
        } else if (index == 1u8) {
            return row.p1;
        } else if (index == 2u8) {
            return row.p2;
        }
        
        return row.p3;
    }
    inline set_point_val(board: Board, i: u8, j: u8, val: u16) -> Board {
        //------------------------------------------------------------
        // Unpacking the vals
        //------------------------------------------------------------
        let r0p0: u16 = board.r0.p0.val;
        let r0p1: u16 = board.r0.p0.val;
        let r0p2: u16 = board.r0.p0.val;
        let r0p3: u16 = board.r0.p0.val;
        
        let r1p0: u16 = board.r0.p0.val;
        let r1p1: u16 = board.r0.p0.val;
        let r1p2: u16 = board.r0.p0.val;
        let r1p3: u16 = board.r0.p0.val;

        let r2p0: u16 = board.r0.p0.val;
        let r2p1: u16 = board.r0.p0.val;
        let r2p2: u16 = board.r0.p0.val;
        let r2p3: u16 = board.r0.p0.val;

        let r3p0: u16 = board.r0.p0.val;
        let r3p1: u16 = board.r0.p0.val;
        let r3p2: u16 = board.r0.p0.val;
        let r3p3: u16 = board.r0.p0.val;
        //------------------------------------------------------------
        // Updating the val
        //------------------------------------------------------------
        if (i == 0u8) {
            if (j == 0u8) {
                r0p0 = val;
            } else if (j == 1u8) {
                r0p1 = val;
            } else if (j == 1u8) {
                r0p2 = val;
            } else {
                r0p3 = val;
            }
        } else if (i == 1u8) {
            if (j == 0u8) {
                r1p0 = val;
            } else if (j == 1u8) {
                r1p1 = val;
            } else if (j == 1u8) {
                r1p2 = val;
            } else {
                r1p3 = val;
            }
        }
        if (i == 2u8) {
            if (j == 0u8) {
                r2p0 = val;
            } else if (j == 1u8) {
                r2p1 = val;
            } else if (j == 1u8) {
                r2p2 = val;
            } else {
                r2p3 = val;
            }
        } else {
            if (j == 0u8) {
                r3p0 = val;
            } else if (j == 1u8) {
                r3p1 = val;
            } else if (j == 1u8) {
                r3p2 = val;
            } else {
                r3p3 = val;
            }
        }
        //------------------------------------------------------------
        // Packing the board back
        //------------------------------------------------------------
        return Board {
            r0: Row {p0: Point {x: 0u8, y: 0u8, val: r0p0}, p1: Point {x: 1u8, y: 0u8, val: r0p1}, p2: Point {x: 2u8, y: 0u8, val: r0p2}, p3: Point {x: 3u8, y: 0u8, val: r0p3}},
            r1: Row {p0: Point {x: 0u8, y: 1u8, val: r1p0}, p1: Point {x: 1u8, y: 1u8, val: r1p1}, p2: Point {x: 2u8, y: 1u8, val: r1p2}, p3: Point {x: 3u8, y: 1u8, val: r1p3}},
            r2: Row {p0: Point {x: 0u8, y: 2u8, val: r2p0}, p1: Point {x: 1u8, y: 2u8, val: r2p1}, p2: Point {x: 2u8, y: 2u8, val: r2p2}, p3: Point {x: 3u8, y: 2u8, val: r2p3}},
            r3: Row {p0: Point {x: 0u8, y: 3u8, val: r3p0}, p1: Point {x: 1u8, y: 3u8, val: r3p1}, p2: Point {x: 2u8, y: 3u8, val: r3p2}, p3: Point {x: 3u8, y: 3u8, val: r3p3}}
        };
    }

    inline pack_board(row0: Buffer, row1: Buffer, row2: Buffer, row3: Buffer) -> Board {
        return Board {
            r0: Row {p0: Point {x: 0u8, y: 0u8, val: row0.v0}, p1: Point {x: 1u8, y: 0u8, val: row0.v1}, p2: Point {x: 2u8, y: 0u8, val: row0.v2}, p3: Point {x: 3u8, y: 0u8, val: row0.v3}},
            r1: Row {p0: Point {x: 0u8, y: 1u8, val: row1.v0}, p1: Point {x: 1u8, y: 1u8, val: row1.v1}, p2: Point {x: 2u8, y: 1u8, val: row1.v2}, p3: Point {x: 3u8, y: 1u8, val: row1.v3}},
            r2: Row {p0: Point {x: 0u8, y: 2u8, val: row2.v0}, p1: Point {x: 1u8, y: 2u8, val: row2.v1}, p2: Point {x: 2u8, y: 2u8, val: row2.v2}, p3: Point {x: 3u8, y: 2u8, val: row2.v3}},
            r3: Row {p0: Point {x: 0u8, y: 3u8, val: row3.v0}, p1: Point {x: 1u8, y: 3u8, val: row3.v1}, p2: Point {x: 2u8, y: 3u8, val: row3.v2}, p3: Point {x: 3u8, y: 3u8, val: row3.v3}}
        };
    }

    inline pack_board_cols(col0: Buffer, col1: Buffer, col2: Buffer, col3: Buffer) -> Board {
        return Board {
            r0: Row {p0: Point {x: 0u8, y: 0u8, val: col0.v0}, p1: Point {x: 1u8, y: 0u8, val: col1.v0}, p2: Point {x: 2u8, y: 0u8, val: col2.v0}, p3: Point {x: 3u8, y: 0u8, val: col3.v0}},
            r1: Row {p0: Point {x: 0u8, y: 1u8, val: col0.v1}, p1: Point {x: 1u8, y: 1u8, val: col1.v1}, p2: Point {x: 2u8, y: 1u8, val: col2.v1}, p3: Point {x: 3u8, y: 1u8, val: col3.v1}},
            r2: Row {p0: Point {x: 0u8, y: 2u8, val: col0.v2}, p1: Point {x: 1u8, y: 2u8, val: col1.v2}, p2: Point {x: 2u8, y: 2u8, val: col2.v2}, p3: Point {x: 3u8, y: 2u8, val: col3.v2}},
            r3: Row {p0: Point {x: 0u8, y: 3u8, val: col0.v3}, p1: Point {x: 1u8, y: 3u8, val: col1.v3}, p2: Point {x: 2u8, y: 3u8, val: col2.v3}, p3: Point {x: 3u8, y: 3u8, val: col3.v3}}
        };
    }

    inline create_filled_buffer(val: u16) -> Buffer {
        return Buffer {v0: val, v1: val, v2: val, v3: val};
    }

    // Allocates a val to the closest empty space
    inline allocate_to_buffer(buffer: Buffer, element: u16) -> Buffer {
        assert(buffer.v0 == 0u16 || buffer.v1 == 0u16 || buffer.v2 == 0u16 || buffer.v3 == 0u16);
        if (buffer.v0 == 0u16) {
            return Buffer {v0: element, v1: 0u16, v2: 0u16, v3: 0u16};
        }
        if (buffer.v1 == 0u16) {
            return Buffer {v0: buffer.v0, v1: element, v2: 0u16, v3: 0u16};
        }
        if (buffer.v2 == 0u16) {
            return Buffer {v0: buffer.v0, v1: buffer.v1, v2: element, v3: 0u16};
        }
        
        return Buffer {v0: buffer.v0, v1: buffer.v1, v2: buffer.v2, v3: element};
    }

    // Allocates a val to the end empty space
    inline allocate_to_end_buffer(buffer: Buffer, element: u16) -> Buffer {
        assert(buffer.v0 == 0u16 || buffer.v1 == 0u16 || buffer.v2 == 0u16 || buffer.v3 == 0u16);
        if (buffer.v3 == 0u16) {
            return Buffer {v0: 0u16, v1: 0u16, v2: 0u16, v3: element};
        }
        if (buffer.v2 == 0u16) {
            return Buffer {v0: 0u16, v1: 0u16, v2: element, v3: buffer.v3};
        }
        if (buffer.v1 == 0u16) {
            return Buffer {v0: 0u16, v1: element, v2: buffer.v2, v3: buffer.v3};
        }
        
        return Buffer {v0: element, v1: buffer.v1, v2: buffer.v2, v3: buffer.v3};
    }

    // Puts the spaces where are needed depending on the
    // movement side so all the buffer blocks go in there
    // Side options: 0 - top, 1 - right, 2 - bottom, 3 - left
    inline get_spaced_buffer(buffer: Buffer, side: u8) -> Buffer {
        let new_buffer: Buffer = create_filled_buffer(0u16);
        if (side == 1u8 || side == 2u8) {
            if (buffer.v3 > 0u16) {new_buffer = allocate_to_end_buffer(new_buffer, buffer.v3);}
            if (buffer.v2 > 0u16) {new_buffer = allocate_to_end_buffer(new_buffer, buffer.v2);}
            if (buffer.v1 > 0u16) {new_buffer = allocate_to_end_buffer(new_buffer, buffer.v1);}
            if (buffer.v0 > 0u16) {new_buffer = allocate_to_end_buffer(new_buffer, buffer.v0);}
        }

        return new_buffer;
    }

    // Calculates buffer movement: 0 - top, 1 - right, 2 - bottom, 3 - left
    // if buffer is a column, first element is considered the highest
    function calculate_buffer(buffer: Buffer, side: u8) -> Buffer {
        let new_buffer: Buffer = create_filled_buffer(0u16);

        if (buffer.v0 == buffer.v1) {
            new_buffer = allocate_to_buffer(new_buffer, buffer.v0 * 2u16);
            if (buffer.v2 == buffer.v3) { new_buffer = allocate_to_buffer(new_buffer, buffer.v2 * 2u16); }
            else { 
                new_buffer = allocate_to_buffer(new_buffer, buffer.v2);
                new_buffer = allocate_to_buffer(new_buffer, buffer.v3);
            }
        } else if (buffer.v1 == buffer.v2) {
            new_buffer = allocate_to_buffer(new_buffer, buffer.v0);
            new_buffer = allocate_to_buffer(new_buffer, buffer.v1 * 2u16);
            new_buffer = allocate_to_buffer(new_buffer, buffer.v3);
        } else if (buffer.v2 == buffer.v3) {
            new_buffer = allocate_to_buffer(new_buffer, buffer.v0);
            new_buffer = allocate_to_buffer(new_buffer, buffer.v1);
            new_buffer = allocate_to_buffer(new_buffer, buffer.v2 * 2u16);
        }

        new_buffer = get_spaced_buffer(new_buffer, side);

        return new_buffer;
    }

    inline row_to_buffer(row: Row) -> Buffer {
      return Buffer {v0: row.p0.val, v1: row.p1.val, v2: row.p2.val, v3: row.p3.val};
    }

    //------------------------------------------------------------
    // Main Game Logic
    //------------------------------------------------------------

    mapping games: address => Game;

    transition init_game() -> Game {
        let empty_game: Game = create_empty_game(0u16);
        return empty_game then finalize(self.caller, empty_game);
    }

    finalize init_game(caller: address, game: Game) {
        assert(!Mapping::contains(games, caller) || Mapping::get(games, caller).status != 0u8);
        Mapping::set(games, caller, game);
    }

    transition make_move(side: u8) -> Game {
        assert(Mapping::contains(games, caller));
        let current_game: Game = Mapping::get(games, self.caller);
        let board: Board = current_game.board;

        if (side == 0u8 || side == 2u8) { // vertical
          let col0: Buffer = Buffer {v0: board.r0.p0.val, v1: board.r1.p0.val, v2: board.r2.p0.val, v3: board.r3.p0.val};
          let col1: Buffer = Buffer {v0: board.r0.p1.val, v1: board.r1.p1.val, v2: board.r2.p1.val, v3: board.r3.p1.val};
          let col2: Buffer = Buffer {v0: board.r0.p2.val, v1: board.r1.p2.val, v2: board.r2.p2.val, v3: board.r3.p2.val};
          let col3: Buffer = Buffer {v0: board.r0.p3.val, v1: board.r1.p3.val, v2: board.r2.p3.val, v3: board.r3.p3.val};

          col0 = calculate_buffer(col0, side);
          col1 = calculate_buffer(col1, side);
          col2 = calculate_buffer(col2, side);
          col3 = calculate_buffer(col3, side);

          board = pack_board_cols(col0, col1, col2, col3);
        } else { // horizontal
          let row0: Buffer = row_to_buffer(board.r0);
          let row1: Buffer = row_to_buffer(board.r1);
          let row2: Buffer = row_to_buffer(board.r2);
          let row3: Buffer = row_to_buffer(board.r3);

          row0 = calculate_buffer(row0, side);
          row1 = calculate_buffer(row1, side);
          row2 = calculate_buffer(row2, side);
          row3 = calculate_buffer(row3, side);

          board = pack_board(row0, row1, row2, row3);
        }

        return current_game then finalize(board, current_game, self.caller);
    }

    finalize make_move(board: Board, game: Game, caller: address) {
        game = Game {board: board, score: game.score, status: game.status};
        Mapping::set(games, caller, game);
    }
}