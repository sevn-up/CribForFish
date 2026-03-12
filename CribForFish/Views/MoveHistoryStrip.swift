import SwiftUI

struct MoveHistoryStrip: View {
    let moves: [Move]
    let players: [PlayerState]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                if moves.isEmpty {
                    Text("No moves yet")
                        .font(.caption2)
                        .foregroundStyle(BoardTheme.secondaryText)
                } else {
                    ForEach(Array(moves.suffix(20).enumerated()), id: \.offset) { _, move in
                        HStack(spacing: 3) {
                            Circle()
                                .fill(colorForPlayer(move.playerIndex))
                                .frame(width: 8, height: 8)
                            Text("+\(move.points)")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(colorForPlayer(move.playerIndex).opacity(0.2))
                        )
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 24)
        .background(BoardTheme.headerBackground)
    }

    private func colorForPlayer(_ index: Int) -> Color {
        guard index >= 0 && index < players.count else { return .white }
        return players[index].color.color
    }
}
