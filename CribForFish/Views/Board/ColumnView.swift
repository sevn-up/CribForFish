import SwiftUI

/// A column of 6 rows = 30 holes.
struct ColumnView: View {
    let section: Int
    let column: Int
    let players: [PlayerState]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<6, id: \.self) { row in
                let firstHole = BoardLayout.holeNumber(
                    section: section,
                    column: column,
                    row: row,
                    position: 0
                )
                HoleRowView(
                    section: section,
                    column: column,
                    row: row,
                    players: players
                )
                .id(firstHole)
            }
        }
    }
}
