import Foundation

enum BoardLayout {
    static let totalHoles = 121
    static let holesPerStreet = 60
    static let holesPerColumn = 30
    static let holesPerRow = 5
    static let rowsPerColumn = 6
    /// Convert a board position (section, column, row, position) to a hole number (1-121).
    ///
    /// Board layout per street (60 holes):
    ///   Left column goes UP (rows 0-5, 30 holes), turnaround, right column goes DOWN (rows 5-0, 30 holes)
    ///
    /// - Parameters:
    ///   - section: 0 = first street (holes 1-60), 1 = second street (holes 61-120)
    ///   - column: 0 = left (ascending), 1 = right (descending)
    ///   - row: 0-5 (top to bottom visually, but hole numbers go bottom-to-top for left column)
    ///   - position: 0-4 (left to right within the row of 5)
    /// - Returns: Hole number 1-121
    static func holeNumber(section: Int, column: Int, row: Int, position: Int) -> Int {
        let sectionOffset = section * holesPerStreet

        if column == 0 {
            // Left column: goes from top (row 0) to bottom (row 5)
            // Row 0 = holes 1-5, Row 1 = holes 6-10, ..., Row 5 = holes 26-30
            return sectionOffset + row * holesPerRow + position + 1
        } else {
            // Right column: goes from bottom (row 5) to top (row 0)
            // Row 5 = holes 31-35, Row 4 = holes 36-40, ..., Row 0 = holes 56-60
            let invertedRow = (rowsPerColumn - 1) - row
            return sectionOffset + holesPerColumn + invertedRow * holesPerRow + position + 1
        }
    }

    /// Returns the section (0 or 1), column (0 or 1), and row where a given hole is located.
    /// Used for auto-scrolling to keep the leading peg visible.
    static func location(forHole hole: Int) -> (section: Int, column: Int, row: Int) {
        guard hole >= 1 && hole <= totalHoles else {
            return (0, 0, 0)
        }

        if hole == 121 {
            return (1, 1, 0) // winning hole at the top of section 1
        }

        let section = (hole - 1) / holesPerStreet
        let positionInStreet = (hole - 1) % holesPerStreet

        if positionInStreet < holesPerColumn {
            // Left column
            let row = positionInStreet / holesPerRow
            return (section, 0, row)
        } else {
            // Right column
            let positionInColumn = positionInStreet - holesPerColumn
            let invertedRow = positionInColumn / holesPerRow
            let row = (rowsPerColumn - 1) - invertedRow
            return (section, 1, row)
        }
    }
}
