export const TOTAL_HOLES = 121;
export const HOLES_PER_ROW = 5;
export const TOTAL_ROWS = 24; // 120 holes / 5 per row

/**
 * Serpentine layout: even rows go left→right, odd rows go right→left.
 * Creates a natural snaking path like a real cribbage board.
 */
export function holeNumber(row: number, position: number): number {
  const base = row * HOLES_PER_ROW;
  if (row % 2 === 0) {
    return base + position + 1;
  } else {
    return base + (HOLES_PER_ROW - 1 - position) + 1;
  }
}

/**
 * Returns the (row, displayPosition) for a given hole number (1-120).
 */
export function location(hole: number): { row: number; position: number } {
  if (hole < 1 || hole > 120) return { row: 0, position: 0 };
  const zeroIndexed = hole - 1;
  const row = Math.floor(zeroIndexed / HOLES_PER_ROW);
  const posInRow = zeroIndexed % HOLES_PER_ROW;
  if (row % 2 === 0) {
    return { row, position: posInRow };
  } else {
    return { row, position: HOLES_PER_ROW - 1 - posInRow };
  }
}

export function isLeftToRight(row: number): boolean {
  return row % 2 === 0;
}
