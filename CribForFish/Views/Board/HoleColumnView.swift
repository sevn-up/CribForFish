import SwiftUI

/// A vertical stack of 3 player dots for a single hole position.
struct HoleColumnView: View {
    let holeNumber: Int
    let players: [PlayerState]

    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<players.count, id: \.self) { playerIndex in
                HoleDotView(
                    holeNumber: holeNumber,
                    playerIndex: playerIndex,
                    players: players
                )
            }
        }
        .frame(width: 22)
    }
}
