import SwiftUI

struct GameView: View {
    var engine: any GameEngineProtocol

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

                Color.white.opacity(0.1).frame(height: 1)

                CompactScoreInputBar(engine: engine)
            }

            if engine.isGameOver, let winnerIdx = engine.winnerIndex {
                WinOverlayView(
                    winnerName: engine.players[winnerIdx].name,
                    winnerColor: engine.players[winnerIdx].color.color,
                    onNewGame: { engine.newGame(playerCount: nil) }
                )
            }
        }
    }
}
