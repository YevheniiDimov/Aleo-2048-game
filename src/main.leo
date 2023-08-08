// The 'game_2048' program.
program game_2048.aleo {
    // Point class represents a single tile
    struct Point {
        x: u8,
        y: u8,
        value: u16
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
        score: u16
    }

    // As Leo doesn't support normal arrays by
    // default, there is a need to normalize
    // the syntax by making the helper functions
    // (But they don't look nice either)
    //------------------------------------------------------------
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

    inline create_empty_board() -> Board {
        return Board {
            r0: Row {p0: Point {x: 0u8, y: 0u8, value: 0u16}, p1: Point {x: 1u8, y: 0u8, value: 0u16}, p2: Point {x: 2u8, y: 0u8, value: 0u16}, p3: Point {x: 3u8, y: 0u8, value: 0u16}},
            r1: Row {p0: Point {x: 0u8, y: 1u8, value: 0u16}, p1: Point {x: 1u8, y: 1u8, value: 0u16}, p2: Point {x: 2u8, y: 1u8, value: 0u16}, p3: Point {x: 3u8, y: 1u8, value: 0u16}},
            r2: Row {p0: Point {x: 0u8, y: 2u8, value: 0u16}, p1: Point {x: 1u8, y: 2u8, value: 0u16}, p2: Point {x: 2u8, y: 2u8, value: 0u16}, p3: Point {x: 3u8, y: 2u8, value: 0u16}},
            r3: Row {p0: Point {x: 0u8, y: 3u8, value: 0u16}, p1: Point {x: 1u8, y: 3u8, value: 0u16}, p2: Point {x: 2u8, y: 3u8, value: 0u16}, p3: Point {x: 3u8, y: 3u8, value: 0u16}}
        };
    }

    inline set_point_value(board: Board, i: u8, j: u8, value: u16) -> Board {
        //------------------------------------------------------------
        // Unpacking the values
        //------------------------------------------------------------
        let r0p0: u16 = board.r0.p0.value;
        let r0p1: u16 = board.r0.p0.value;
        let r0p2: u16 = board.r0.p0.value;
        let r0p3: u16 = board.r0.p0.value;
        
        let r1p0: u16 = board.r0.p0.value;
        let r1p1: u16 = board.r0.p0.value;
        let r1p2: u16 = board.r0.p0.value;
        let r1p3: u16 = board.r0.p0.value;

        let r2p0: u16 = board.r0.p0.value;
        let r2p1: u16 = board.r0.p0.value;
        let r2p2: u16 = board.r0.p0.value;
        let r2p3: u16 = board.r0.p0.value;

        let r3p0: u16 = board.r0.p0.value;
        let r3p1: u16 = board.r0.p0.value;
        let r3p2: u16 = board.r0.p0.value;
        let r3p3: u16 = board.r0.p0.value;
        //------------------------------------------------------------
        // Updating the value
        //------------------------------------------------------------
        if (i == 0u8) {
            if (j == 0u8) {
                r0p0 = value;
            } else if (j == 1u8) {
                r0p1 = value;
            } else if (j == 1u8) {
                r0p2 = value;
            } else {
                r0p3 = value;
            }
        } else if (i == 1u8) {
            if (j == 0u8) {
                r1p0 = value;
            } else if (j == 1u8) {
                r1p1 = value;
            } else if (j == 1u8) {
                r1p2 = value;
            } else {
                r1p3 = value;
            }
        }
        if (i == 2u8) {
            if (j == 0u8) {
                r2p0 = value;
            } else if (j == 1u8) {
                r2p1 = value;
            } else if (j == 1u8) {
                r2p2 = value;
            } else {
                r2p3 = value;
            }
        } else {
            if (j == 0u8) {
                r3p0 = value;
            } else if (j == 1u8) {
                r3p1 = value;
            } else if (j == 1u8) {
                r3p2 = value;
            } else {
                r3p3 = value;
            }
        }
        //------------------------------------------------------------
        // Packing the board back
        //------------------------------------------------------------
        return Board {
            r0: Row {p0: Point {x: 0u8, y: 0u8, value: r0p0}, p1: Point {x: 1u8, y: 0u8, value: r0p1}, p2: Point {x: 2u8, y: 0u8, value: r0p2}, p3: Point {x: 3u8, y: 0u8, value: r0p3}},
            r1: Row {p0: Point {x: 0u8, y: 1u8, value: r1p0}, p1: Point {x: 1u8, y: 1u8, value: r1p1}, p2: Point {x: 2u8, y: 1u8, value: r1p2}, p3: Point {x: 3u8, y: 1u8, value: r1p3}},
            r2: Row {p0: Point {x: 0u8, y: 2u8, value: r2p0}, p1: Point {x: 1u8, y: 2u8, value: r2p1}, p2: Point {x: 2u8, y: 2u8, value: r2p2}, p3: Point {x: 3u8, y: 2u8, value: r2p3}},
            r3: Row {p0: Point {x: 0u8, y: 3u8, value: r3p0}, p1: Point {x: 1u8, y: 3u8, value: r3p1}, p2: Point {x: 2u8, y: 3u8, value: r3p2}, p3: Point {x: 3u8, y: 3u8, value: r3p3}}
        };
    }

    inline create_filled_buffer(val: u16) -> Buffer {
        return Buffer {v0: val, v1: val, v2: val, v3: val};
    }

    // Allocates a value to the closest empty space
    inline allocate_to_buffer(buffer: Buffer, element: u16) -> Buffer {
        assert(buffer.v0 == 0u16 || buffer.v1 == 0u16 || buffer.v2 == 0u16 || buffer.v3 == 0u16)
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

    // Allocates a value to the end empty space
    inline allocate_to_end_buffer buffer(buffer: Buffer, element: u16) -> Buffer {
        assert(buffer.v0 == 0u16 || buffer.v1 == 0u16 || buffer.v2 == 0u16 || buffer.v3 == 0u16)
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
    //------------------------------------------------------------

    mapping games: address => Game;
    
    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}