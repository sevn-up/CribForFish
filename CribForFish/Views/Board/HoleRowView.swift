import SwiftUI

/// A single hole position showing all player pegs side by side horizontally.
/// Used in the vertical board layout where holes run top-to-bottom.
struct HoleRowView: View {
    let holeNumber: Int
    let players: [PlayerState]

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<players.count, id: \.self) { idx in
                HoleDotView(
                    holeNumber: holeNumber,
                    playerIndex: idx,
                    players: players
                )
            }
        }
    }
}
