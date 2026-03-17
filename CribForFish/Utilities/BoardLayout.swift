import Foundation

enum BoardLayout {
    static let totalHoles = 121
    static let holesPerRow = 5
    static let totalRows = 24 // 120 holes / 5 per row

    /// Serpentine layout: even rows go left→right, odd rows go right→left.
    /// This creates a natural snaking path down the screen, like tracing
    /// your finger along a real cribbage board.
    static func holeNumber(row: Int, position: Int) -> Int {
        let base = row * holesPerRow
        if row.isMultiple(of: 2) {
            return base + position + 1
        } else {
            return base + (holesPerRow - 1 - position) + 1
        }
    }

    /// Returns the (row, displayPosition) for a given hole number (1-120).
    static func location(forHole hole: Int) -> (row: Int, position: Int) {
        guard hole >= 1 && hole <= 120 else { return (0, 0) }
        let zeroIndexed = hole - 1
        let row = zeroIndexed / holesPerRow
        let posInRow = zeroIndexed % holesPerRow
        if row.isMultiple(of: 2) {
            return (row, posInRow)
        } else {
            return (row, holesPerRow - 1 - posInRow)
        }
    }

    static func isLeftToRight(row: Int) -> Bool {
        row.isMultiple(of: 2)
    }
}
