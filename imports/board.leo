program helloworld.aleo {
    inline extract_row(board: u64, index: field) -> u64 {
        let row3_mask: u64 = 65535u64;
        let row2_mask: u64 = 4294901760u64;
        let row1_mask: u64 = 281470681743360u64;
        let row0_mask: u64 = 18446462598732840960u64;
        let row: u64 = board;

        if (index == 0field) {row &= row3_mask; }
        else if (index == 1field) {row &= row2_mask; }
        else if (index == 2field) {row &= row1_mask; }
        else {row &= row0_mask; }

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

    inline extract_tile(row: u64, index: u8, shift: u8) -> u64 {
      let mask: u64 = 15u64 * 16u64.pow(index);
      let tile: u64 = row & mask;  
      tile = tile >> 4u8.mul(index);
      return tile << shift;
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
    
    transition get_row(board: u64) -> u64 {
        return extract_row(board, 3field);
    }

    transition get_col(board: u64) -> u64 {
        return extract_column(board, 2u8);
    }

    transition get_tiles(board: u64) -> (u64, u64, u64, u64) {
        let row: u64 = extract_row(board, 3field);
        let tiles: (u64, u64, u64, u64) = extract_tiles(row);
        return tiles;
    }
}