//
//  ContentView.swift
//  CribForFish
//
//  Created by Sev Nielsen on 2026-02-28.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @State private var engine = GameEngine()

    var body: some View {
        ZStack {
            OceanTheme.headerBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                ScoreHeaderView(
                    players: engine.players,
                    activeIndex: engine.activePlayerIndex
                )

                Color.white.opacity(0.1).frame(height: 1)

                GameBoardView(
                    players: engine.players,
                    leadingHole: engine.leadingHole
                )

                Color.white.opacity(0.1).frame(height: 1)

                ScoreInputView(engine: engine)
            }

            if engine.isGameOver, let winnerIdx = engine.winnerIndex {
                WinOverlayView(
                    winnerName: engine.players[winnerIdx].name,
                    winnerColor: engine.players[winnerIdx].color.color,
                    onNewGame: { engine.newGame() }
                )
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            engine.load(context: modelContext)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                engine.save()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: GameState.self, inMemory: true)
}
