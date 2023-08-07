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

    // Board for the game consists of 4 rows
    // This way making a matrix of 4x4 tiles
    struct Board {
        r0: Row,
        r1: Row,
        r2: Row,
        r3: Row,
    }

    // As Leo doesn't support normal arrays by
    // default, there is a need to normalize
    // the syntax by making the helper functions
    // (But they don't look nice either)
    //------------------------------------------------------------
    function get_row_by_index(board: Board, index: u8) -> Row {
        if (index == 0u8) {
            return board.r0;
        }
        else if (index == 1u8) {
            return board.r1;
        }
        else if (index == 2u8) {
            return board.r2;
        }
        
        return board.r3;
    }

    function get_point_by_index(row: Row, index: u8) -> Point {
        if (index == 0u8) {
            return row.p0;
        }
        else if (index == 1u8) {
            return row.p1;
        }
        else if (index == 2u8) {
            return row.p2;
        }
        
        return row.p3;
    }

    function create_empty_board() -> Board {
        return Board {
            r0: Row {p0: Point {x: 0u8, y: 0u8, value: 0u16}, p1: Point {x: 1u8, y: 0u8, value: 0u16}, p2: Point {x: 2u8, y: 0u8, value: 0u16}, p3: Point {x: 3u8, y: 0u8, value: 0u16}},
            r1: Row {p0: Point {x: 0u8, y: 1u8, value: 0u16}, p1: Point {x: 1u8, y: 1u8, value: 0u16}, p2: Point {x: 2u8, y: 1u8, value: 0u16}, p3: Point {x: 3u8, y: 1u8, value: 0u16}},
            r2: Row {p0: Point {x: 0u8, y: 2u8, value: 0u16}, p1: Point {x: 1u8, y: 2u8, value: 0u16}, p2: Point {x: 2u8, y: 2u8, value: 0u16}, p3: Point {x: 3u8, y: 2u8, value: 0u16}},
            r3: Row {p0: Point {x: 0u8, y: 3u8, value: 0u16}, p1: Point {x: 1u8, y: 3u8, value: 0u16}, p2: Point {x: 2u8, y: 3u8, value: 0u16}, p3: Point {x: 3u8, y: 3u8, value: 0u16}},
        };
    }

    function clean_board(board: Board) -> Board {
        board.r0.p0.value = 0;
        board.r0.p1.value = 0;
        board.r0.p2.value = 0;
        board.r0.p3.value = 0;

        board.r1.p0.value = 0;
        board.r1.p1.value = 0;
        board.r1.p2.value = 0;
        board.r1.p3.value = 0;

        board.r2.p0.value = 0;
        board.r2.p1.value = 0;
        board.r2.p2.value = 0;
        board.r2.p3.value = 0;

        board.r3.p0.value = 0;
        board.r3.p1.value = 0;
        board.r3.p2.value = 0;
        board.r3.p3.value = 0;

        return board;
    }

    function set_point_value(board: Board, i: u8, j: u8, value: u16) -> Board {
        if (i == 0u8) {
            if (j == 0u8) {
                board.r0.p0 = value;
            }
            else if (j == 1u8) {
                board.r0.p1 = value;
            }
            else if (j == 1u8) {
                board.r0.p2 = value;
            }
            else {
                board.r0.p3 = value;
            }
        }
        else if (i == 1u8) {
            if (j == 0u8) {
                board.r1.p0 = value;
            }
            else if (j == 1u8) {
                board.r1.p1 = value;
            }
            else if (j == 1u8) {
                board.r1.p2 = value;
            }
            else {
                board.r1.p3 = value;
            }
        }
        if (i == 2u8) {
            if (j == 0u8) {
                board.r2.p0 = value;
            }
            else if (j == 1u8) {
                board.r2.p1 = value;
            }
            else if (j == 1u8) {
                board.r2.p2 = value;
            }
            else {
                board.r2.p3 = value;
            }
        }
        else {
            if (j == 0u8) {
                board.r3.p0 = value;
            }
            else if (j == 1u8) {
                board.r3.p1 = value;
            }
            else if (j == 1u8) {
                board.r3.p2 = value;
            }
            else {
                board.r3.p3 = value;
            }
        }

        return board;
    }

    function create_empty_buffer() -> Row {
        return Row {p0: Point {x: 0u8, y: 0u8, value: 0u16}, p1: Point {x: 1u8, y: 0u8, value: 0u16}, p2: Point {x: 2u8, y: 0u8, value: 0u16}, p3: Point {x: 3u8, y: 0u8, value: 0u16}};
    }
    //------------------------------------------------------------

    mapping games: address -> Board;

    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}
