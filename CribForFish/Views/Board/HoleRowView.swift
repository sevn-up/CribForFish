import SwiftUI

/// A row of 5 hole positions (one group of 5).
struct HoleRowView: View {
    let section: Int
    let column: Int
    let row: Int
    let players: [PlayerState]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<5, id: \.self) { position in
                let hole = BoardLayout.holeNumber(
                    section: section,
                    column: column,
                    row: row,
                    position: position
                )
                HoleColumnView(holeNumber: hole, players: players)
            }
        }
    }
}
