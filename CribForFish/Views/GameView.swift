import SwiftUI

struct GameView: View {
    var engine: any GameEngineProtocol
    @State private var showWinOverlay = true

    var body: some View {
        ZStack {
            BoardTheme.headerBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                ScoreHeaderView(
                    players: engine.players,
                    activeIndex: engine.activePlayerIndex,
                    onSelectPlayer: { engine.selectPlayer($0) }
                )

                Color.white.opacity(0.1).frame(height: 1)

                GameBoardView(
                    players: engine.players,
                    leadingHole: engine.leadingHole
                )
                .gesture(
                    DragGesture(minimumDistance: 50, coordinateSpace: .local)
                        .onEnded { value in
                            let horizontal = value.translation.width
                            let vertical = value.translation.height
                            guard abs(horizontal) > abs(vertical) else { return }
                            let count = engine.players.count
                            if horizontal > 0 {
                                engine.selectPlayer((engine.activePlayerIndex - 1 + count) % count)
                            } else {
                                engine.selectPlayer((engine.activePlayerIndex + 1) % count)
                            }
                        }
                )

                Color.white.opacity(0.1).frame(height: 1)

                CompactScoreInputBar(
                    engine: engine,
                    showWinOverlay: $showWinOverlay
                )
            }

            if engine.isGameOver && showWinOverlay, let winnerIdx = engine.winnerIndex {
                WinOverlayView(
                    winnerName: engine.players[winnerIdx].name,
                    winnerColor: engine.players[winnerIdx].color.color,
                    players: engine.players,
                    moves: engine.moves,
                    onNewGame: { engine.newGame(playerCount: nil) },
                    onDismiss: { showWinOverlay = false }
                )
            }
        }
        .onChange(of: engine.isGameOver) { _, isOver in
            if isOver {
                showWinOverlay = true
            }
        }
    }
}
