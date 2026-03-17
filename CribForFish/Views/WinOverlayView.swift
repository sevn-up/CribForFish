import SwiftUI

struct WinOverlayView: View {
    let winnerName: String
    let winnerColor: Color
    let players: [PlayerState]
    let moves: [Move]
    let onNewGame: () -> Void
    let onDismiss: () -> Void

    @State private var showStats = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 20) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(winnerColor)

                Text("Game Over!")
                    .font(.title3)
                    .foregroundStyle(BoardTheme.secondaryText)

                Text("\(winnerName) Wins!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("\(winnerScore) points")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.8))

                // Skunk callout
                if let skunkText = skunkCallout {
                    Text(skunkText)
                        .font(.headline)
                        .foregroundStyle(.orange)
                }

                // Game Stats toggle
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showStats.toggle()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chart.bar.fill")
                        Text("Game Stats")
                    }
                    .font(.subheadline)
                    .foregroundStyle(BoardTheme.accent)
                }

                if showStats {
                    statsTable
                }

                Button {
                    onNewGame()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Play Again")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(winnerColor)
                    )
                }
                .padding(.top, 8)

                Button {
                    onDismiss()
                } label: {
                    Text("View Board")
                        .font(.subheadline)
                        .foregroundStyle(BoardTheme.secondaryText)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(BoardTheme.sectionBackground.opacity(0.95))
            )
        }
        .transition(.opacity)
    }

    private var winnerScore: Int {
        players.first(where: { $0.name == winnerName })?.frontPeg ?? 121
    }

    private var skunkCallout: String? {
        let losers = players.filter { $0.name != winnerName }
        let worstScore = losers.map(\.frontPeg).min() ?? 121
        if worstScore < 60 {
            return "💀 Double Skunked!"
        } else if worstScore < 90 {
            return "🦨 Skunked!"
        }
        return nil
    }

    private var statsTable: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 0) {
                Text("Player")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Score")
                    .frame(width: 44)
                Text("Hands")
                    .frame(width: 48)
                Text("Best")
                    .frame(width: 40)
                Text("Avg")
                    .frame(width: 40)
            }
            .font(.caption2)
            .foregroundStyle(BoardTheme.secondaryText)
            .padding(.horizontal, 12)
            .padding(.bottom, 6)

            ForEach(Array(players.enumerated()), id: \.offset) { idx, player in
                let playerMoves = moves.filter { $0.playerIndex == idx }
                let best = playerMoves.map(\.points).max() ?? 0
                let avg = playerMoves.isEmpty ? 0.0 : Double(playerMoves.map(\.points).reduce(0, +)) / Double(playerMoves.count)
                let isWinner = player.name == winnerName

                HStack(spacing: 0) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(player.color.color)
                            .frame(width: 8, height: 8)
                        Text(player.name)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\(player.frontPeg)")
                        .frame(width: 44)
                    Text("\(playerMoves.count)")
                        .frame(width: 48)
                    Text("\(best)")
                        .frame(width: 40)
                    Text(String(format: "%.1f", avg))
                        .frame(width: 40)
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isWinner
                        ? RoundedRectangle(cornerRadius: 6).fill(player.color.color.opacity(0.15))
                        : RoundedRectangle(cornerRadius: 6).fill(Color.clear)
                )
            }
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}
